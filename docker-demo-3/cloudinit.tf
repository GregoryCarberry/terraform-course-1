data "local_file" "jenkins_init" {
  filename = "${path.module}/scripts/jenkins-init.sh"
}


data "cloudinit_config" "cloudinit-jenkins" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    # content      = templatefile("scripts/jenkins-init.sh", {
    # content      = templatefile("${path.module}/scripts/jenkins-init.sh", {
    content = templatefile(data.local_file.jenkins_init.filename, {

      DEVICE          = var.INSTANCE_DEVICE_NAME
      JENKINS_VERSION = var.JENKINS_VERSION
      TERRAFORM_VERSION = var.TERRAFORM_VERSION
    })
  }
}



