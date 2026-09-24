#!/bin/bash
# Phase 1.3 — Install tools on x86_64 Amazon Linux 2023
# Can be run manually or as EC2 User Data

LOG_FILE="/home/ec2-user/install-status.log"

dnf update -y

# Git
dnf install -y git

# Docker
dnf install -y docker
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# eksctl
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz"
tar -xzf eksctl_Linux_amd64.tar.gz -C /tmp
mv /tmp/eksctl /usr/local/bin/
rm -f eksctl_Linux_amd64.tar.gz

# Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Version check report
echo "====================================" > $LOG_FILE
echo "  INSTALL STATUS REPORT" >> $LOG_FILE
echo "  $(date)" >> $LOG_FILE
echo "====================================" >> $LOG_FILE
echo "" >> $LOG_FILE
echo "Git:     $(git --version 2>&1)" >> $LOG_FILE
echo "Docker:  $(docker --version 2>&1)" >> $LOG_FILE
echo "kubectl: $(kubectl version --client 2>&1)" >> $LOG_FILE
echo "eksctl:  $(eksctl version 2>&1)" >> $LOG_FILE
echo "Helm:    $(helm version --short 2>&1)" >> $LOG_FILE
echo "AWS CLI: $(aws --version 2>&1)" >> $LOG_FILE
echo "Arch:    $(uname -m)" >> $LOG_FILE
echo "====================================" >> $LOG_FILE

chown ec2-user:ec2-user $LOG_FILE
touch /home/ec2-user/INSTALL_COMPLETE
