#!/bin/sh

prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt 'ceph_deploy部署ceph分布式文件系统 http://www.cnblogs.com/CLTANG/p/3778510.html'
install_auto_start(){
mycat start
mycat status
}
install_auto_start

