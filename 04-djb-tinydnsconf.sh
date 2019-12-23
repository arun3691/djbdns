#!/bin/bash
confsrc=`pwd`
echo $confsrc
read -p "IP Address for tinydns to listen: " ipaddr
useradd Gtinydns
useradd Gdnslog
tinydns-conf Gtinydns Gdnslog /etc/tinydns $ipaddr
mkdir /var/log/tinydns
chown Gdnslog:Gdnslog /var/log/tinydns
chmod g+s /var/log/tinydns
cp tinydns-log-run /etc/tinydns/log/run
chmod +x /etc/tinydns/log/run

cd /service
ln -s /etc/tinydns
sleep 5
svstat /service/tinydns
