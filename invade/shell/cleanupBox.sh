#!/bin/bash
[ `whoami` = root ] || exec sudo su -c $0

echo 'Cleanup bash history'
unset HISTFILE
[ -f /root/.bash_history ] && rm /root/.bash_history
[ -f /home/vagrant/.bash_history ] && rm /home/vagrant/.bash_history

echo 'Cleanup log files'
find /var/log -type f | while read f; do echo -ne '' > $f; done;

echo 'Cleanup cache and other folders and files'
rm -rf /usr/share/doc
rm -rf /usr/src/linux-headers*
rm -rf /usr/src/vboxguest*
rm -rf /usr/src/virtualbox-ose-guest*
find /var/cache -type f -exec rm -rf {} \;

echo 'Cleanup APT cache'
apt-get -y remove linux-headers-$(uname -r) build-essential > /dev/null
apt-get -y autoremove
apt-get -y clean
