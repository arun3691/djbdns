#!/bin/bash

confsrc=`pwd`
echo $confsrc
yum -y install make gcc figlet
cd /usr/local/src
tar -zxf $confsrc/daemontools-0.76.tar.gz
tar -zxf $confsrc/ucspi-tcp-0.88.tar.gz
tar -zxf $confsrc/djbdns-1.05.tar.gz
cp $confsrc/daemon-error.h admin/daemontools-0.76/src/error.h
cp $confsrc/ucspi-error.h ucspi-tcp-0.88/error.h
cp $confsrc/jumbo-p13.patch /usr/local/src/

#Install daemontools
echo "###########################################################################"
echo "Installing daemontools..."
read -p "Press Enter to continue: "
echo "###########################################################################"
cd /usr/local/src/admin/daemontools-0.76
package/install

echo "###########################################################################"
echo "Adding conf file for svscan..."
echo "###########################################################################"
sleep 1
cat <<EOF >> /etc/init/svscan.conf
start on runlevel [345]
respawn
exec /command/svscanboot
EOF

#Start svscan
sleep 1
echo "###########################################################################"
echo "Starting svscan..."
echo "###########################################################################"

initctl start svscan
sleep 2
ps axu|grep readproc
sleep 2

#Install ucspi-tcp
echo "###########################################################################"
echo "Installing TCP Server(ucspi-tcp)..."
echo "###########################################################################"
sleep 1
cd /usr/local/src/ucspi-tcp-0.88
make
make setup check

#djbdns install
echo "###########################################################################"
echo "Installing djbdns package..."
echo "###########################################################################"
sleep 2
echo
read -p "Press Enter to continue:"
cd /usr/local/src/djbdns-1.05
patch -p1 < $confsrc/jumbo-p13.patch
echo gcc -O2 -include /usr/include/errno.h > conf-cc
make
make setup check

echo "###################################################################################"
echo "Done...Please check above logs for any issue being reported. Else go to 2nd script."
echo "###################################################################################"
echo "###################################################################################"
echo "~~~Good Luck!~~~"
echo "###################################################################################"
