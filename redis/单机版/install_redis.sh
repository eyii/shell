#!/bin/sh

redis_version='-3.2.3'
REDIS_GEM_VERSION='-update-2.6.11'
prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt 'CentOS 7 上安装 redis3.2.3安装与配置'
prompt 'http://www.cnblogs.com/sandea/p/5782192.html'


prompt '安装rubygems'
down(){
read -p "输入y跳过安装" is_install
if [ $is_install == "y" ]
then
echo '已跳过安装'
else
cd /usr/local
rm -rf  rubygems*
wget https://rubygems.org/gems/rubygems$1.gem
gem install -l ./rubygems$1.gem
fi
}
down $REDIS_GEM_VERSION

prompt '安装运行环境'
yum_env(){
read -p "输入y跳过安装" is_install
if [ $is_install == "y" ]
then
echo '已跳过安装'
else
yum  -y install ruby
yum -y install rubygems
yum -y install zlib
yum -y install ruby
gem update --system
fi
}
yum_env

install_gem_install_redis_gem(){

}


prompt '#修改gem源码 安装redis  下面要等比较久请耐心等待'
xiugai_gemyuan(){
read -p "输入y跳过安装" is_install
if [ $is_install == "y" ]
then
echo '已跳过安装'
else
	gem sources --remove https://rubygems.org/
	gem sources --a http://gems.github.com
	gem sources --a http://gems.ruby-china.org/
	gem sources -u
	gem install redis
fi
}
xiugai_gemyuan

prompt '下载redis'
down_redis(){
read -p "is install" install
#如果是空的
if [ -n $install ]
then
echo 'tiaoguo'
else
yum -y install tcl
cd /usr/local
rm -rf redis*
wget http://download.redis.io/releases/redis$1.tar.gz
fi
}
down_redis $redis_version


prompt '安装redis'
install_redis(){
read -p "is install" install
#如果是空的
if [ -n $install ]
then
echo 'tiaoguo'
else
cd /usr/local
tar -zxvf redis$1.tar.gz
mv redis$1 redis
cd redis
make && make install
fi
}
install_redis $redis_version


prompt '启动集群服务端'

redis_remote(){
read -p "ip port" isremote port
if [ -n $isremote ]
then
yum -y install ruby
cd /usr/local/redis/utils/create-cluster
mv create-cluster create-cluster.sh
chmod 777 create-cluster.sh
./create-cluster.sh start
./create-cluster.sh create
redis-cli -c -p 9012
cluster nodes
fi
}
redis_remote


prompt '执行完成'
