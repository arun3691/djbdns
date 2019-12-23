#!/bin/bash
#Detect and add init scripts for svscan to be started at boot time.
#Team Infra, Cleartrip
#
osver=`rpm -q centos-release|awk -F '-' '{print $3}'`
echo "Seems this machine is based on CentOS/RHEL version ${osver}."
read -p "Press y to configure auto-start for svscan. Any other key to abort: " response

if [ "${response}" == "y" ]; then
	case ${osver} in
	
		"6")

		initfile="/etc/init/svscan.conf"
		cat<<EOF>$initfile
start on runlevel [345]
respawn
exec /command/svscanboot
EOF

		sleep 3
		echo -n "Starting svscan service now..."
		initctl start svscan
		echo "Done"
		
		ps axu|grep "readproc"
	;;
	
	"7")
		initfile="/usr/lib/systemd/system/svscan.service"
		cat<<EOF>$initfile
[Unit]
Description=daemontools Start supervise
After=getty.target
[Service]
Type=simple
User=root
Group=root
Restart=always
ExecStart=/command/svscanboot /dev/ttyS0
TimeoutSec=0
[Install]
WantedBy=multi-user.target
EOF
		ln -s $initfile /etc/systemd/system/multi-user.target.wants/
		systemctl enable svscan.service
		sleep 3
		echo -n "Starting svscan service now..."
		systemctl start svscan.service
		echo "Done"
		ps axu|grep "readproc"
	;;

	esac


else
	echo "Not enabling autostart for svscan. You need to do it manually before starting apps."
fi
