#! /bin/bash
create_cluster(){
	netstat -lntp
	echo "创建集群======="
	cd $REDIS_HOME/src
	pwd
	prompt "redis-trib"
	./redis-trib.rb create --replicas 1 "${LOCALIP}:6379 ${LOCALIP}:6380 ${LOCALIP}:6381 ${IP_SLAVE}:6379 ${IP_SLAVE}:6380 ${IP_SLAVE}:6381"
	ps aux|grep redis
	./redis-cli -c -h $(get_ip_addr ens33) -p 6379
	#echo cluster nodes
}
