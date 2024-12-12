#!/bin/bash

# Membuat folder sementara
TMP_DIR=/tmp/openssl-openssh-install
mkdir -p $TMP_DIR
cd $TMP_DIR

# Memastikan wget sudah terinstal
sudo yum install -y wget

# Mengunduh OpenSSL
wget https://github.com/alsyundawy/openssh-openssl-el6/raw/main/openssl/openssl_1.0.2k_EL6/ca-certificates-2021.5.20-65.1.el6.noarch.rpm
wget https://github.com/alsyundawy/openssh-openssl-el6/raw/main/openssl/openssl_1.0.2k_EL6/openssl-static-1.0.2k-21.el6.x86_64.rpm
wget https://github.com/alsyundawy/openssh-openssl-el6/raw/main/openssl/openssl_1.0.2k_EL6/openssl-perl-1.0.2k-21.el6.x86_64.rpm
wget https://github.com/alsyundawy/openssh-openssl-el6/raw/main/openssl/openssl_1.0.2k_EL6/openssl-devel-1.0.2k-21.el6.x86_64.rpm
wget https://github.com/alsyundawy/openssh-openssl-el6/raw/main/openssl/openssl_1.0.2k_EL6/openssl-libs-1.0.2k-21.el6.x86_64.rpm
wget https://github.com/alsyundawy/openssh-openssl-el6/raw/main/openssl/openssl_1.0.2k_EL6/openssl-1.0.2k-21.el6.x86_64.rpm

# Menghapus RPM sebelumnya
sudo rpm -e --nodeps openssl ca-certificates

# Menginstal OpenSSL
sudo rpm -Uvh --replacefiles --replacepkgs *.rpm


# Mengunduh OpenSSH
wget https://github.com/alsyundawy/openssh-openssl-el6/raw/main/openssh/OPENSSH-8.9P1.EL6/openssh-8.9p1-1.el6.x86_64.rpm
wget https://github.com/alsyundawy/openssh-openssl-el6/raw/main/openssh/OPENSSH-8.9P1.EL6/openssh-askpass-8.9p1-1.el6.x86_64.rpm
wget https://github.com/alsyundawy/openssh-openssl-el6/raw/main/openssh/OPENSSH-8.9P1.EL6/openssh-askpass-gnome-8.9p1-1.el6.x86_64.rpm
wget https://github.com/alsyundawy/openssh-openssl-el6/raw/main/openssh/OPENSSH-8.9P1.EL6/openssh-clients-8.9p1-1.el6.x86_64.rpm
wget https://github.com/alsyundawy/openssh-openssl-el6/raw/main/openssh/OPENSSH-8.9P1.EL6/openssh-debuginfo-8.9p1-1.el6.x86_64.rpm
wget https://github.com/alsyundawy/openssh-openssl-el6/raw/main/openssh/OPENSSH-8.9P1.EL6/openssh-server-8.9p1-1.el6.x86_64.rpm

# Menghapus RPM sebelumnya
sudo rpm -e --nodeps openssh

# Menginstal OpenSSH
sudo rpm -Uvh --replacefiles --replacepkgs *.rpm

# Membersihkan folder sementara
cd ..
sudo rm -rf $TMP_DIR
