#! /bin/bash
zookeeper_version='-3.4.10'
prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}

promt 'Zookeeper集群安装 http://www.linuxidc.com/Linux/2012-10/72906.htm'
install_down(){
wget http://mirror.bit.edu.cn/apache/zookeeper/stable/zookeeper$zookeeper_version.tar.gz
tar zxvf zookeeper$zookeeper_version.tar.gz
}
install_down


