#!/bin/bash

component=$1

dnf install ansible -y 

git clone https://github.com/aitechwithsundhar-cmd/ansible-roboshop-roles-tf.git

cd ansible-roboshop-roles-tf
ansible-playbook -e component=$component roboshop.yaml