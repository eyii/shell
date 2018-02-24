#!/bin/sh

redis_version='2.8.19'
prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt 'CentOS7安装keepalived http://blog.chinaunix.net/uid-28266791-id-5699541.html'




prompt '下载keepalived'
down_keepalived(){
cd /usr/local/src
wget http://www.keepalived.org/software/keepalived-1.2.20.tar.gz
yum -y install tcl
}

down_keepalived

prompt '安装keepalived'
install_keepalived(){
tar -xvf keepalived-1.2.20.tar.gz
cd keepalived-1.2.20
./configure --prefix=/usr/local/keepalived
make
make install
}
install_keepalived 

prompt '建立服务启动脚本，以便使用service命令控制'
install_keepalived_service(){
cp /usr/local/keepalived/etc/rc.d/init.d/keepalived  /etc/init.d/keepalived
chmod +x /etc/init.d/keepalived
sed -i 's%/etc/sysconfig/keepalived%usr/local/keepalived/etc/sysconfig/keepalived%' /etc/init.d/keepalived
PATH="$PATH:/usr/local/keepalived/sbin"
export PATH
#4.修改/usr/local/keepalived/etc/sysconfig/keepalived文件，设置正确的服务启动参数
#KEEPALIVED_OPTIONS="-D -f /usr/local/keepalived/etc/keepalived/keepalived.conf"
}
install_keepalived_service
prompt '执行完成'
