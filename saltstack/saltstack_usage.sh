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
#前期环境配置

promt '六、使用SaltStack http://www.centoscn.com/image-text/config/2015/0426/5282.html'


prompt '1、在master端查看公钥列表'
install_down(){
salt-key -L
}
install_down

prompt '2、测试被控主机的连通性、硬盘的使用率、网络接口地址'
install_down(){
salt '*' test.ping
salt '*' disk.usage
salt '*' network.interfaces
}
install_down

prompt '3、远程执行命令测试 cmd模块包含的shell的输出在被控端,比如cmd.run and cmd.run_all'
install_down(){
salt '*' cmd.run date
salt '*' cmd.run uptime
salt '*' cmd.run 'df -h'
salt '*' cmd.run 'ls -l /etc'
}
install_down


prompt 'pkg函数自动映射本地系统的包管理到salt函数'
install_down(){
salt '*' pkg.install vim
}
install_down

