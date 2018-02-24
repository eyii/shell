#! /bin/bash
source config.sh
source api.sh
source system_config.sh
source uninstall_redis.sh
source installenv_1.sh
source loop_change_redis_conf_3.sh
source install_redis_1.sh
source start_redis_server_with_conf.sh
source create_cluster.sh

all(){
killall -9 redis-server
system_config

for((i=0;i<100;i++))
do
	read -p '请选择
	[1]=installenv  [2]=install_redis_1 [3]=loop_change_redis_conf_3
	[4]=start_redis_server_with_conf_4
	[5]=create_cluster
	
	
	
	
	
	' commond
	case $commond in 
	[1])
	echo 'installenv_1'
	for_echo_eq;
	installenv_main_1
	;;
	[2])
	echo 'install_redis_1.sh===install_redis_1'
	for_echo_eq
	install_redis_1
	;;
	[3])
	echo 'change.sh  loop_change_redis_conf_3'
	for_echo_eq
	loop_change_redis_conf_3 $PORT_FORM $PORT_TO
	;;
	[4])
	echo '执行代码为====start_redis_server_with_conf_4 $PORT_FORM $PORT_TO '
	for_echo_eq
	start_redis_server_with_conf_4 $PORT_FORM $PORT_TO 
	;;
	[5])
	echo '执行代码为====create_cluster'
	for_echo_eq
	create_cluster
	;;
	esac
done

}

all
end::

