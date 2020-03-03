#!/bin/sh
#
# makeDownloader v0.1
# Script to make "serratus-Downloader" AMI
#
# Base Image: Amazon Linux 2
# AMI: ami-0e8c04af2729ff1bb
# login: ec2-user@<ipv4>
# base: 9 Gb
#
# Image: serratus-Downloader
# Desc : (v0.1) bioinformatics seq-database access
# AMI  : ami-01c471b9b490a03f3 (us-west-2)

# Software
# AWSCLI -- pre-installed on amazon linux
SAMTOOLSVERSION='1.10'
SRATOOLKITVERSION='2.10.4'
GDCVERSION='1.5.0'

# DEPENDENCY ====================================
# Update core
sudo yum update
sudo yum clean all

# Python3 3.7.4 and pip3
sudo yum install python3
sudo yum install python3-devel
alias python=python3

curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
rm get-pip.py

# Libraries for htslib
sudo yum install make gcc libc-dev
sudo yum install unzip bzip2-devel xz-devel zlib-devel
sudo yum install ncurses-devel
sudo yum install curl-devel

# SAMTOOLS ======================================
# /usr/local/bin/samtools
wget -O samtools-"$SAMTOOLSVERSION".tar.bz2 \
  https://github.com/samtools/samtools/releases/download/"$SAMTOOLSVERSION"/samtools-"$SAMTOOLSVERSION".tar.bz2

tar xvjf samtools-"$SAMTOOLSVERSION".tar.bz2 && rm samtools-"$SAMTOOLSVERSION".tar.bz2

cd samtools-"$SAMTOOLSVERSION"
  make
  sudo make install
cd .. && rm -rf samtools-*

# SRATOOLKIT=====================================
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/"$SRATOOLKITVERSION"/setup-apt.sh
sudo ./setup-apt.sh && rm ./setup-apt.sh
# Add to $PATH:/usr/local/ncbi/sra-tools/bin
source /etc/profile.d/sra-tools.sh

# Test command:
# fastq-dump --stdout -X 2 SRR390728

# See: https://github.com/ncbi/sra-tools/wiki/04.-Cloud-Credentials
# To access SRA cloud-data, you'll need to provide 
# your AWS (Amazon Web Services) access key or GCP 
# (Google Cloud Platform) service account to vdb-config.

# GDC-CLIENT ====================================
wget https://gdc.cancer.gov/system/files/authenticated%20user/0/gdc-client_v"$GDCVERSION"_Ubuntu_x64.zip

unzip gdc-client_v"$GDCVERSION"_Ubuntu_x64.zip
rm    gdc-client_v"$GDCVERSION"_Ubuntu_x64.zip
sudo mv gdc-client /usr/local/bin/


# Clean-up
sudo yum clean all
sudo rm -rf /var/cache/yum

# Save AMI
# ami (us-west-2): ami-059b454759561d9f4
