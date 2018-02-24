#!/bin/sh

prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt '2下载安装mycat-web'
prompt '安装zookeeper'
install_zookeeper(){
cd /usr/local
java -version
rm -rf zookeeper*
wget http://apache.fayea.com/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz
ll zookeeper-3.4.8.tar.gz
tar -zxvf zookeeper-3.4.8.tar.gz
cd /usr/local/zookeeper-3.4.8/conf
grep -v "^#" zoo_sample.cfg
cp zoo_sample.cfg zoo.cfg
cd /usr/local/zookeeper-3.4.8/bin
./zkServer.sh start
netstat -ant | grep 2181
}
install_zookeeper

prompt '安装mycat-web'
install_mycat_web(){
cd /usr/local
rm -rf Mycat-web*
wget https://raw.githubusercontent.com/MyCATApache/Mycat-download/master/mycat-web-1.0/Mycat-web$1.tar.gz
file Mycat-web$1.tar.gz
mkdir /usr/local/mycat-web
tar -zxvf Mycat-web$1.tar.gz -C /usr/local/
cd /usr/local/mycat-web
./start.sh
netstat -ant | grep 8082
iptables -L -nv | grep 8082
}
install_mycat_web -1.0-SNAPSHOT-20160617163048-linux


prompt '执行完成'
