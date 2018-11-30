#!/bin/bash

# --------------------------------------------------
# kubernetes preperation script
# written by Martin Schmidt (itze@mailbox.org)
# repo: https://github.com/itzecode/kube-init
# --------------------------------------------------
# Step 2: prepare master
# --------------------------------------------------

# Get IP 
# !! this helper only works if your working in a 10.x.x.x network !!
# --------------------------------------------------
myIP=`ifconfig  | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}' | grep "^10"`

# Initialize cluster using the flannel virtual network
kubeadm init --apiserver-advertise-address=$myIP --pod-network-cidr=10.244.0.0/16

# to be continued
