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



prompt 'yum安装docker'
install_yum_docker(){
yum install docker
yum -y install docker-io
service docker start
chkconfig docker on
systemctl start docker.service
systemctl enable docker.service
}
install_yum_docker

prompt '更换docker为阿里云镜像'
install_docker_aliyun(){
cp -n /lib/systemd/system/docker.service /etc/systemd/system/docker.service
sudo sed -i “s|ExecStart=/usr/bin/dockerd|ExecStart=/usr/bin/dockerd –registry-mirror=https://pee6w651.mirror.aliyuncs.com|g” /etc/systemd/system/Docker.service
prompt 'ExecStart=/usr/bin/dockerd –registry-mirror=http://hub-mirror.c.163.com  网易的'
}
install_yum_docker




prompt '执行完成'
