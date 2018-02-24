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

prompt 'SaltStack安装（CentOS7.x） http://www.cnblogs.com/qlwang/p/5036488.html'

prompt '1.导入SaltStack仓库key：'
install_down(){
yum -y install wget
wget 'https://repo.saltstack.com/yum/redhat/7.3/x86_64/latest/SALTSTACK-GPG-KEY.pub'
rpm --import SALTSTACK-GPG-KEY.pub
rm -f SALTSTACK-GPG-KEY.pub
}
install_down


prompt '2.创建新的YUM源文件并“/etc/yum.repos.d/saltstack.repo”编辑如下内容'
install_down(){
# Enable SaltStack's package repository
if [ -f '/etc/yum.repos.d/saltstack.repo' ]
	then
	rm -f /etc/yum.repos.d/saltstack.repo
	touch '/etc/yum.repos.d/saltstack.repo'
	else 
	touch '/etc/yum.repos.d/saltstack.repo'
fi
echo "[saltstack-repo]" >> /etc/yum.repos.d/saltstack.repo
sed -i '$a\name=SaltStack repo for RHEL/CentOS 7' /etc/yum.repos.d/saltstack.repo
sed -i '$a\baseurl=https://repo.saltstack.com/yum/redhat/7.3/x86_64/latest/' /etc/yum.repos.d/saltstack.repo
sed -i '$a\enabled=1' /etc/yum.repos.d/saltstack.repo
sed -i '$a\gpgcheck=1' /etc/yum.repos.d/saltstack.repo
sed -i '$a\gpgkey=https://repo.saltstack.com/yum/redhat/7.3/x86_64/latest/SALTSTACK-GPG-KEY.pub' /etc/yum.repos.d/saltstack.repo
yum clean expire-cache
yum -y update
}
install_down


install_master(){
yum -y install salt-master
chkconfig salt-master on
systemctl restart salt-master.service
ipaddress=$(ifconfig | sed -n 2p | awk '{print $2}')
sed -i "s/#interface: 0.0.0.0/ interface: "$ipaddress"/g" /etc/salt/master
}



install_minion(){
yum -y install salt-minion
read -p 'enter server ipaddress' ipaddress
sed -i "s/#master: 0.0.0.0/ master: "$ipaddress"/g" /etc/salt/minion
cat  /etc/salt/minion | grep "^  master"
chkconfig salt-minion on
systemctl restart salt-minion.service
echo 'minion无法连接master'
echo '查看debug信息：salt-minion -l debug'
}

install_accept(){
#查看minion列表
salt-key -L
#接收所有key：
salt-key -A
echo 'salt Docker test.ping'
#注意：master和interface前面有两个空格，如果没有启动的时候回出现错误；
}

#5.启动服务：
prompt '3.安装SaltStack软件'
install_down(){
read -p 'a:install_master b:install_minion c:install_accept' op
case $op in
     a)
	install_master;;
	b)
	install_minion;;
	c)
	install_accept;;
	*)
	echo "error"
esac
}
install_down




