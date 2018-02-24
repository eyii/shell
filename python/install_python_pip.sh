#! /bin/bash
install_path=/usr/local
prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}

prompt '安装依赖包'
install_depencence(){
yum -y install zlib-devel
yum -y install bzip2-devel
yum -y install openssl-devel
yum -y install ncurses-devel
yum -y install sqlite-devel
}
install_depencence

prompt '下载python'
down_python(){
rpm -ivh 'http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm'
yum -y install python-pip
}
down_python 3.5.3


#ln -s /usr/local/bin/python2.7 /usr/local/bin/python