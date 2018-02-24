#! /bin/bash
#卸载redis
uninstall_redis(){
	prompt "======删除之前的文件redis系列文件和目录=====$REDIS_HOME==========="
	killall redis-server
	rm -rf $REDIS_HOME
	for((i=$1;$i<=$2;i++));do
	rm -f /etc/init.d/redis*
	rm -f /tmp/redis*
	rm -f /var/run/redis*
	done
	unset i
	rm -rf $REDIS_HOME
}
