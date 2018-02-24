#! /bin/bash

#复制redis_conf
cp_redis_conf_to_dir_conf(){
	prompt "cp__redis.conf到$1"
	cp $REDIS_HOME/redis.conf $1
}




#设置daemonize
set_redis_conf_daemonize(){
	prompt "daemonize===设置允许后台运行文件路径===========$1============="
	sed -i "s/daemonize no/daemonize yes/g" $1
}


#设置端口
set_redis_conf_port(){
	prompt "port=================端口$1===========文件路径====$2============"
	sed -i "s/port 6379/port $1/g" $2
}


#设置cluster-enabled
set_redis_conf_cluster-enabled(){
	prompt "cluster-enabled=============文件路径============$1"
	echo "cluster-enabled yes" >>$1
}



#设置node_timeout
set_redis_conf_cluster_node_timeout(){
	prompt "cluster-node-timeout"
	echo "cluster-node-timeout $2" >>$1
}




#设置appendonly
set_redis_conf_appendonly(){
	prompt "appendonly"
	sed -i "s/appendonly no/appendonly yes/g" $1
}




#设置cluster-config-file名
set_redis_conf_cluster_config_file_nodename(){
	prompt "cluster-config-file"
	echo "cluster-config-file nodes-$1.conf" >>$2
}




#设置appendfilename
set_redis_conf_appendfilename(){
	#prompt "appendfilename"
	DEFAULT='appendfilename "appendonly.aof"'
	NEW_PATH="appendfilename \"appendonly_$2.aof\""
	sed -i "s#$DEFAULT#$NEW_PATH#g" $1
}




#设置dbfilename
set_redis_conf_dbfilename(){
	prompt "dbfilename"
	sed -i "s#dbfilename dump.rdb#dbfilename dump_$2.rdb#g" $1
}



#设置pidfile_path
set_redis_conf_pidfile_path(){
	prompt "pidfile"
	DEFAULT='pidfile /var/run/redis_6379.pid'
	NEW_PATH="pidfile /tmp/redis_$2.pid"
	sed -i "s#$DEFAULT#$NEW_PATH#g" $1
	unset DEFAULT NEW_PATH
}



#设置redis_conf_dir
set_redis_conf_dir(){
	prompt "dir"
	DEFAULT='dir ./'
	NEW="dir $REDIS_HOME/data"
	sed -i "s#$DEFAULT#$NEW#g" $1
	unset DEFAULT NEW
}



#设置logfile_path
set_logfile_path(){
	prompt "logfile"
	LOGFILE_PATH=$REDIS_HOME/log/redis_$1.log
	sed -i "s#logfile \"\"#logfile \"$LOGFILE_PATH\"#g" $2
}

#设置loglevel_verbose
set_loglevel_verbose(){
	prompt 'loglevel_verbose'
	DEFAULT='loglevel notice'
	NEW="loglevel verbose"
	sed -i "s#$DEFAULT#$NEW#g" $1
	unset DEFAULT NEW
}

#绑定IP
set_bind(){
    read -p '请输入网卡的名称' name
	prompt "bind =====$(get_ip_addr $name)"
	sed -i "s/bind 127.0.0.1/bind $(get_ip_addr $name)/g" $1
	#or j in ${clxx[@]}
	#do
	#echo "bind $j" >>$1
	#one 
	#uset j
}




#设置protected-mode
set_protected_mode_no(){
	prompt 'protected-mode no'
	DEFAULT='protected-mode yes'
	NEW="protected-mode no"
	sed -i "s#$DEFAULT#$NEW#g" $1
	unset DEFAULT NEW
}



#更改配置文件
change(){
	cd $REDIS_HOME
	REDIS_CONF_PATH=$REDIS_HOME/conf/redis_$1.conf
	cp_redis_conf_to_dir_conf $REDIS_CONF_PATH
	#修改配置文件
	set_redis_conf_daemonize $REDIS_CONF_PATH
	set_redis_conf_port $1 $REDIS_CONF_PATH
	set_loglevel_verbose $REDIS_CONF_PATH
	set_redis_conf_cluster-enabled $REDIS_CONF_PATH
	set_redis_conf_cluster_node_timeout $REDIS_CONF_PATH $REDIS_CONF_TIMEOUT
	set_protected_mode_no $REDIS_CONF_PATH
	read -p "请输入网卡的名称" name
	
	set_bind $REDIS_CONF_PATH $name
	set_redis_conf_appendonly $REDIS_CONF_PATH
	set_redis_conf_cluster_config_file_nodename $1 $REDIS_CONF_PATH
	set_redis_conf_appendfilename $REDIS_CONF_PATH $1
	set_redis_conf_dir $REDIS_CONF_PATH
	set_logfile_path $1 $REDIS_CONF_PATH
	set_redis_conf_pidfile_path $REDIS_CONF_PATH $1
	set_redis_conf_dbfilename $REDIS_CONF_PATH $1
	unset REDIS_CONF_PATH
}




#循环更改
loop_change_redis_conf_3(){
prompt '⑵回车开始配置redis.conf并且启动服务============================redis"'
create_dir $REDIS_HOME
for((i=$1;i<=$2;i++));do
	change $i 
done
unset i
}
