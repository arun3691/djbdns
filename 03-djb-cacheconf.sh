#!/bin/bash
confsrc=`pwd`
echo $confsrc
sleep 2
read -p "IP Address for dnscache to listen: " ipaddr
echo "Creating user accounts Gdnscache and Gdnslog"
sleep 1
useradd Gdnscache
useradd Gdnslog
echo "Running dnscache-conf to configure external forwarding cache..."
sleep 2
dnscache-conf Gdnscache Gdnslog /etc/dnscache $ipaddr
echo "Creating and configuring dnscache log location (/var/log/dnscache)"
sleep 2
mkdir /var/log/dnscache/
chown Gdnslog:Gdnslog /var/log/dnscache/
chmod g+s /var/log/dnscache/
cp dnscache-log-run /etc/dnscache/log/run
chmod +x /etc/dnscache/log/run

echo "Downloading latest DNS root server info..."
wget ftp://ftp.internic.net/domain/named.root
wget http://thedjbway.b0llix.net/djbdns/djbroot.sed
echo "Processing latest DNS root server info -"
echo "updating the same in dnscache..."
sed -f djbroot.sed named.root > dnsroots.global
cp dnsroots.global /etc/dnsroots.global
cp dnsroots.global /etc/dnscache/root/servers/@
echo "Enabling round-robin caches..."
echo > /etc/dnscache/env/ROUNDROBIN

echo "Starting dnscache service..."
cd /service
ln -s /etc/dnscache
sleep 5
echo "Checking status of dnscache..."
svstat /service/dnscache
