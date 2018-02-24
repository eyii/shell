#! /bin/bash
#修改系统参数
system_config(){
	killall -9 redis-server
	sudo sysctl vm.overcommit_memory=1
	sed -i "s/root soft nofile 65535/root soft nofile 102400/g" /etc/security/limits.conf
	sed -i "s/root hard nofile 65535/root hard nofile 102400/g" /etc/security/limits.conf
	service cron restart
	service crond restart
	sysctl -w net.core.somaxconn=32767
	echo net.core.somaxconn = 32767 >>/etc/sysctl.conf
	sysctl -p
	echo never > /sys/kernel/mm/transparent_hugepage/enabled >>/etc/rc.local
}

