#!/bin/bash

# Remove previous builds
rm -rf ~/rpmbuild openssh-8.9p1

# Install necessary packages
yum install -y pam-devel rpm-build rpmdevtools zlib-devel openssl-devel krb5-devel gcc gtk2-devel imake libXt-devel

# Create the SOURCES directory for rpmbuild and navigate to it
mkdir -p ~/rpmbuild/SOURCES
cd ~/rpmbuild/SOURCES

# Download OpenSSH source and signature files
wget -c https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.9p1.tar.gz
wget -c https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.9p1.tar.gz.asc

# Verify the downloaded tarball (if GPG keys are available)
gpg --verify openssh-8.9p1.tar.gz.asc openssh-8.9p1.tar.gz

# Extract the tarball
tar zxvf openssh-8.9p1.tar.gz

# Copy the PAM configuration for sshd
cp /etc/pam.d/sshd openssh-8.9p1/contrib/redhat/sshd.pam
cp /etc/pam.d/sshd openssh-8.9p1/contrib/redhat/sshd.pam.old

# Backup and recreate the tarball with updated PAM config
mv openssh-8.9p1.tar.gz{,.orig}
tar zcpf openssh-8.9p1.tar.gz openssh-8.9p1

# Remove the line 'BuildRequires: openssl-devel < 1.1' from the spec file
sed -i '/BuildRequires: openssl-devel < 1.1/d' openssh-8.9p1/contrib/redhat/openssh.spec

# Edit the openssh.spec file
sed -i 's/%define no_gnome_askpass 0/%define no_gnome_askpass 1/g' openssh-8.9p1/contrib/redhat/openssh.spec
sed -i 's/%define no_x11_askpass 0/%define no_x11_askpass 1/g' openssh-8.9p1/contrib/redhat/openssh.spec
sed -i 's/BuildPreReq/BuildRequires/g' openssh-8.9p1/contrib/redhat/openssh.spec
sed -i 's/PreReq: initscripts >= 5.00/#PreReq: initscripts >= 5.00/g' openssh-8.9p1/contrib/redhat/openssh.spec

# Change ownership to root:root (if necessary)
chown root:root openssh-8.9p1/contrib/redhat/openssh.spec

# Download missing dependencies if necessary
wget -c https://src.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-1.2.4.1.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-1.2.4.1.tar.gz -O ~/rpmbuild/SOURCES/x11-ssh-askpass-1.2.4.1.tar.gz

# Build the RPM package
rpmbuild -ba openssh-8.9p1/contrib/redhat/openssh.spec
