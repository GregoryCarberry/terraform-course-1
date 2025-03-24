#!/bin/bash
set -e  # Exit script if any command fails

echo "Building AMI with Packer..."
ARTIFACT=$(packer build -machine-readable packer-example.json | tee /tmp/packer_output | awk -F, '$0 ~/artifact,0,id/ {print $6}')
AMI_ID=$(echo $ARTIFACT | awk -F: '{print $2}')

if [ -z "$AMI_ID" ]; then
  echo "Error: Failed to extract AMI ID. Check Packer output in /tmp/packer_output."
  exit 1
fi

echo "AMI ID generated: $AMI_ID"

echo 'variable "AMI_ID" { default = "'${AMI_ID}'" }' > amivar.tf
echo "Generated Terraform variable file: amivar.tf"

echo "Initializing Terraform..."
terraform init

echo "Applying Terraform..."
terraform apply -auto-approve
