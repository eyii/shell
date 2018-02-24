#! /bin/bash

prompt '启动redis服务'

start_redis_server_with_conf_4(){
	killall -9 redis-server
	prompt "start redis-server"
	if [ ! -d $REDIS_HOME ]; then
	prompt "${REDIS_HOME}==目录不存在";
	fi
	cd $REDIS_HOME/src/
	read -p "⑵回车开始配置redis.conf并且启动服务============================redis"
	for((i=$1;i<=$2;i++));do
	rm -f $REDIS_HOME/log/redis_$i.log
	echo "配置文件路径为==================$REDIS_HOME/conf/redis_$i.conf"
	./redis-server $REDIS_HOME/conf/redis_$i.conf
	cat $REDIS_HOME/log/redis_$i.log
	done
	unset i
	netstat -lntp
}