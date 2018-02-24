#! /bin/bash
source config.sh
source api.sh
source system_config.sh
source uninstall_redis.sh
source installenv_1.sh
source loop_change_redis_conf.sh
source install_redis_1.sh
source start_redis_server_with_conf.sh
source create_cluster.sh



all(){


for((i=0;i<100;i++))
do
	read -p '请选择
	[0]=修改系统参数
	[1]=installenv  [2]=install_redis_1 [3]=loop_change_redis_conf_3
	[4]=start_redis_server_with_conf_4
	[5]=create_cluster [6]=卸载集群
	
	
	
	
	
	' commond
	case $commond in 
	[0])
	prompt "0修改系统配置"
	system_config
	;;
	[1])
	prompt "1安装运行环境"
	installenv_main_1
	;;
	[2])
	prompt '2安装redis install_redis_1.sh'
	install_redis_1
	;;
	[3])
	prompt '3修改配置文件'
	loop_change_redis_conf_3 $PORT_FORM $PORT_TO
	;;
	[4])
	prompt '4启动所有redis进程'
	start_redis_server_with_conf_4 $PORT_FORM $PORT_TO 
	;;
	[5])
	prompt '创建集群'
	create_cluster
	;;
	[6])
	prompt '卸载集群'
	uninstall_redis
	;;
	esac
done

}

all
end::
