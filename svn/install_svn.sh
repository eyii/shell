#!/bin/sh

prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt 'centos7.2安装svn'
down_pycharm(){
sed -i 's#keepcache=0#keepcache=1#g' /etc/yum.conf
yum -y install subversion
}
down_pycharm 

prompt '配置启动SVN'
conf_svn(){
mkdir -p /var/svn/svnrepos
svnadmin create /var/svn/svnrepos
}
install_pycharm 2016.3.2

prompt '执行完成'
