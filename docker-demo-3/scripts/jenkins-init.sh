#!/bin/bash
set -e  # Exit on error

## **🔹 STEP 1: EBS VOLUME SETUP (Ensures Jenkins has persistent storage)**
vgchange -ay

# DEVICE_FS=$(blkid -o value -s TYPE "${DEVICE}")
DEVICE_FS=$(lsblk -no FSTYPE ${DEVICE})
if [ -z "$DEVICE_FS" ]; then
  DEVICENAME=$(basename "${DEVICE}")
  DEVICEEXISTS=''

  while [[ -z $DEVICEEXISTS ]]; do
    printf '⚠️ Checking if device %s is attached...\n' "$DEVICENAME"
    DEVICEEXISTS=$(lsblk | grep "$DEVICENAME" | wc -l)
    if [[ $DEVICEEXISTS != "1" ]]; then
      sleep 15
    fi
  done

  pvcreate "${DEVICE}"
  vgcreate data "${DEVICE}"
  lvcreate --name volume1 -l 100%FREE data
  mkfs.ext4 /dev/data/volume1
fi

mkdir -p /var/lib/jenkins
echo '/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0' | tee -a /etc/fstab
if ! mountpoint -q /var/lib/jenkins; then
    mount /var/lib/jenkins
fi

## **🔹 STEP 2: INSTALL SYSTEM DEPENDENCIES**
apt-get update
apt-get install -y python3-pip unzip docker.io openjdk-17-jre  # No need for PPA

## **🔹 STEP 3: INSTALL JENKINS PROPERLY**
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update
apt-get install -y jenkins="${JENKINS_VERSION}"

# **Ensure Jenkins user exists before modifying it**
if id "jenkins" &>/dev/null; then
    printf '✅ Jenkins user exists, adding to Docker group...\n'
    usermod -aG docker jenkins
else
    printf '⚠️ Jenkins user does not exist. Creating user...\n'
    useradd -m -s /bin/bash jenkins
    usermod -aG docker jenkins
fi

# **Enable and start Jenkins properly**
systemctl enable --now jenkins || {
    printf '🚨 Jenkins failed to start, retrying...\n'
    systemctl restart jenkins
}

# **Verify Jenkins is running, else fail script**
if ! systemctl is-active --quiet jenkins; then
    printf '❌ ERROR: Jenkins is not running! Check logs: journalctl -u jenkins --no-pager\n'
    exit 1
fi

## **🔹 STEP 4: ENABLE DOCKER & ENSURE JENKINS CAN ACCESS IT**
usermod -aG docker jenkins
systemctl enable --now docker

## **🔹 STEP 5: INSTALL AWS CLI**
pip install awscli

## **🔹 STEP 6: INSTALL TERRAFORM PROPERLY**
TERRAFORM_VERSION="1.11.1"
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

## **🔹 STEP 7: FINAL CLEANUP**
apt-get clean

printf '✅ SETUP COMPLETED SUCCESSFULLY!\n'
exit 0 # Exit with success

