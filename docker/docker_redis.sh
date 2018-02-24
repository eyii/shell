#!/bin/sh

mysql1='192.168.0.151'
mysql2='192.168.0.151'
MYCAT_HOME=/usr/local/mycat

prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt 'centos7 安装docker'
prompt 'http://www.linuxidc.com/Linux/2014-12/110034.htm'



prompt 'docker_reids_cluster'
docker_reids_cluster(){
docker search redis-cluster
docker pull docker.io/grokzen/redis-cluster

}
docker_reids_cluster

prompt '更换docker为阿里云镜像'
install_docker_aliyun(){

}
install_yum_docker




prompt '执行完成'
