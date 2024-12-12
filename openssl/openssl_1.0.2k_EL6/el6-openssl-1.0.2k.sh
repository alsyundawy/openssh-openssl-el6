#!/bin/bash

# Exit script on any error
set -e

# Install required packages
echo "Installing required packages..."
yum install -y wget krb5-devel zlib-devel lksctp-tools-devel util-linux make gcc rpm-build

# Download the source RPM for OpenSSL
OPENSSL_RPM_URL="https://vault.centos.org/7.9.2009/updates/Source/SPackages/openssl-1.0.2k-21.el7_9.src.rpm"
OPENSSL_RPM_NAME="openssl-1.0.2k-21.el7_9.src.rpm"
echo "Downloading OpenSSL source RPM..."
curl -o $OPENSSL_RPM_NAME $OPENSSL_RPM_URL

# Install the source RPM
rpm -i $OPENSSL_RPM_NAME

# Navigate to SOURCES directory and modify patch files
echo "Modifying patch files..."
cd ~/rpmbuild/SOURCES/
sed -i 's/secure_getenv(/getenv(/g' *.patch

# Navigate to SPECS directory and update spec file
echo "Updating spec file..."
cd ../SPECS/
wget -c https://server-support.co/openssl-el6/openssl.spec -O openssl.spec
#sed -i 's/%patch68 -p1 -b .secure-getenv/#%patch68 -p1 -b .secure-getenv/g' openssl.spec
#sed -i '/%check/,/make test/d' openssl.spec  # Skip %check

# Build the RPM
echo "Building OpenSSL RPM..."
rpmbuild -bb openssl.spec

# Install the newly built RPMs
echo "Installing built RPMs..."
cd ../RPMS/x86_64
rpm -U --force openssl-libs-1.0.2k-21.el6.x86_64.rpm openssl-1.0.2k-21.el6.x86_64.rpm openssl-devel-1.0.2k-21.el6.x86_64.rpm openssl-static-1.0.2k-21.el6.x86_64.rpm openssl-perl-1.0.2k-21.el6.x86_64.rpm


# Success message
echo "OpenSSL has been successfully built and installed."
