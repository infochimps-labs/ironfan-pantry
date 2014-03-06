#!/bin/sh
# Edit the config files
sed -n  '/GSSAPIDelegateCredentials/!p' /etc/ssh/ssh_config > /etc/ssh/temp && mv /etc/ssh/temp /etc/ssh/ssh_config
sed -n  '/PasswordAuthentication/!p' /etc/ssh/sshd_config > /etc/ssh/temp && mv /etc/ssh/temp /etc/ssh/sshd_config
cat <<EOF >> /etc/ssh/sshd_config
UsePAM yes
AuthorizedKeysCommand /usr/bin/sss_ssh_authorizedkeys
GSSAPIAuthentication yes
AuthorizedKeysCommandUser nobody
PasswordAuthentication yes
EOF

# Restart the services
service ssh restart
service sssd restart
