#!/bin/bash

# Set the desired version of Terraform
TERRAFORM_VERSION="1.10.5"

# Set the architecture (x86_64 is default for most systems)
ARCHITECTURE="amd64"

# Download the Terraform zip package
echo "Downloading Terraform version ${TERRAFORM_VERSION}..."
curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCHITECTURE}.zip"

# Unzip the downloaded package
echo "Unzipping Terraform..."
unzip -qq terraform_${TERRAFORM_VERSION}_linux_${ARCHITECTURE}.zip

# Move the Terraform binary to /usr/local/bin
echo "Moving Terraform to /usr/local/bin..."
sudo mv terraform /usr/local/bin/

# Clean up the downloaded zip file
rm terraform_${TERRAFORM_VERSION}_linux_${ARCHITECTURE}.zip

# Verify the installation
echo "Verifying Terraform installation..."
terraform --version

echo "Terraform installation completed!"
