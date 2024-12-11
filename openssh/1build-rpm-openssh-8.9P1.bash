#!/bin/bash

# Install necessary packages
yum install -y pam-devel rpm-build rpmdevtools zlib-devel openssl-devel krb5-devel gcc gtk2-devel imake libXt-devel

# Create the SOURCES directory for rpmbuild and navigate to it
mkdir -p ~/rpmbuild/SOURCES
cd ~/rpmbuild/SOURCES

# Download the OpenSSH source and signature files
wget -c https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.9p1.tar.gz
wget -c https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.9p1.tar.gz.asc

# Verify the downloaded tarball (uncomment if GPG keys are set up)
gpg --verify openssh-8.9p1.tar.gz.asc openssh-8.9p1.tar.gz

# Extract the tarball
tar zxvf openssh-8.9p1.tar.gz

# Copy the PAM configuration for sshd from the system to the source directory
cp /etc/pam.d/sshd openssh-8.9p1/contrib/redhat/sshd.pam
cp /etc/pam.d/sshd openssh-8.9p1/contrib/redhat/sshd.pam.old

# Backup the original tarball
mv openssh-8.9p1.tar.gz{,.orig}

# Recreate the tarball with the updated PAM configuration
tar zcpf openssh-8.9p1.tar.gz openssh-8.9p1

# Extract the source files for editing
cd ~
tar zxvf ~/rpmbuild/SOURCES/openssh-8.9p1.tar.gz openssh-8.9p1/contrib/redhat/openssh.spec

# Change ownership to root:root if necessary (usually required by RPM build process)
chown root:root ~/openssh-8.9p1/contrib/redhat/openssh.spec

# Edit the spec file
cd openssh-8.9p1/contrib/redhat/
sed -i -e "s/%define no_gnome_askpass 0/%define no_gnome_askpass 1/g" openssh.spec
sed -i -e "s/%define no_x11_askpass 0/%define no_x11_askpass 1/g" openssh.spec
sed -i -e "s/BuildPreReq/BuildRequires/g" openssh.spec
# If encountering a build error with the following line, comment it out
sed -i -e "s/PreReq: initscripts >= 5.00/#PreReq: initscripts >= 5.00/g" openssh.spec

# Ensure the missing source file is not required or download it
# If necessary, download the missing file
# wget -c http://ftp.example.com/path/to/x11-ssh-askpass-1.2.4.1.tar.gz -O ~/rpmbuild/SOURCES/x11-ssh-askpass-1.2.4.1.tar.gz
wget -c https://src.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-1.2.4.1.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-1.2.4.1.tar.gz -O ~/rpmbuild/SOURCES/x11-ssh-askpass-1.2.4.1.tar.gz
# Build the RPM package
rpmbuild -ba openssh.spec

