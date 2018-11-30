#!/bin/bash

# --------------------------------------------------
# kubernetes preperation script
# written by Martin Schmidt (itze@mailbox.org)
# repo: https://github.com/itzecode/kube-init
# --------------------------------------------------
# Step 1: prepare base on all nodes
# --------------------------------------------------

# update system ------------------------------------
yum update -y

# Disable swap -------------------------------------
swapoff -a
sed -i "`grep -n swap /etc/fstab | awk -F: '{ print $1; }'`s/^/#/" /etc/fstab

# Disable SELinux ----------------------------------
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# Enable br_netfilter kernel module ----------------
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

# Install docker -----------------------------------
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
systemctl enable docker.service
systemctl start  docker.service

# Install Kubernetes Repository --------------------
cat <<EOF > /etc/yum.repos.d/active/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubelet kubeadm kubectl

# next step ---------------------------------------
echo ""; echo " >> next, run prepareMaster.sh or prepareNode.sh based on the role!"; echo ""
