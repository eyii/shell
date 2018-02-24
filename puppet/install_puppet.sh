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


prompt 'CentOS7.2系统环境中安装saltstack详细配置过程讲解 http://www.itnpc.com/news/web/146085374956616.html'

install_down(){

}
install_down