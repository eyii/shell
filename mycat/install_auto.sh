#!/bin/sh

prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt '正在启动脚本文件'
install_auto_start(){
mycat start
mycat status
}
install_auto_start

