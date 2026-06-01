#!/bin/bash

# we are creating root disk, but only 20gb is partitioned 
# remaning 30Gg we need to extend using below commands 
# growpart /dev/nvme0n1 4
# lvextend -r  -L +30G /dev/mapper/RootVG-homeVol
# xfs_growfs /home 

yum install -y yum-utils 
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install terraform