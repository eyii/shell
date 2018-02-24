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
prompt '1、salt-master的配置安装准备工作'
prompt '1.1、查看CentOS的版本和其内核的版本及安装配置阿里云yum源'
install_down(){
cat /etc/redhat-release 
#CentOS Linux release 7.2.1511 (Core) 
#uname -r
yum -y install wget
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all 
yum makecache
yum -y update
}
install_down

prompt '#1.2、安装epel-release和salt-master工具包'
install_epel(){
yum install epel-release -y
}
install_epel

prompt '#1.7、修改selinux为Permissive模式'
install_firewalld(){
setenforce 0
getenforce
systemctl disable firewalld.service
systemctl stop firewalld.service
}
install_firewalld


prompt '#2.2、安装epel-release工具包和salt-minion客户端'
install_master(){
yum -y install salt-master
chkconfig salt-master on
systemctl restart salt-master
ipaddress=$(ifconfig | sed -n 2p | awk '{print $2}')
sed -i "s/#interface: 0.0.0.0/ interface: "$ipaddress"/g" /etc/salt/master
}

install_minion(){
yum install epel-release -y
yum -y install salt-minion
systemctl enable salt-minion
read -p 'enter server ipaddress' ipaddress
if [ cat /etc/salt/minion |grep $ipaddress ]
	then
	echo 'exists'
else
sed -i "s/#master: salt/ master: "$ipaddress"/g" /etc/salt/minion
fi
cat  /etc/salt/minion | grep "master"
chkconfig salt-minion on
systemctl start salt-minion.service
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


prompt '3、saltstack的具体操作'
install_config(){
salt-key -L
cd /etc/salt/pki/master/minions_pre/
ls
cat salt-minion-0*
#PUBLICK KEY
prompt '从上面的信息我们可以看出Unaccepted Keys:存放路径为：/etc/salt/pki/master/minions_pre'
salt-key -A -y      	#添加salt-key
salt-key -L	#查看salt-key
salt salt-minion* test.ping	#简单测试

# salt-minion-01:
#    True

salt salt-minion* cmd.run 'uname -r'	#运行linux命令
#salt-minion-01:
#   3.10.0-327.el7.x86_64
prompt 'salt-key -a saltstack-minion 指定某台 minion 进行认证 key  3、接着继续查看 minion 列表 （这时候saltstack-minion 已经变为绿色，说明 key 已被添加）'
salt-key -a saltstack-minion
}

#5.启动服务：
prompt '3.安装SaltStack软件'
install_Salt(){
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
install_Salt

