#!/bin/sh

redis_version='-3.2.3'

prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt 'CentOS 7 上安装 redis3.2.3安装与配置 http://www.cnblogs.com/sandea/p/5782192.html'
prompt '下载redis'
down_redis(){
yum -y install tcl
cd /usr/local
rm -rf redis*
wget http://download.redis.io/releases/redis$1.tar.gz
}
down_redis $redis_version


prompt '安装redis'
install_redis(){
cd /usr/local
tar -zxvf redis$1.tar.gz
mv redis$1 redis
cd redis
make && make install

}
install_redis $redis_version

prompt '运行redis服务端'
yunxing_redis(){
cd /usr/local/redis/utils/
./install_server.sh
ifconfig
redis-cli --version
}
yunxing_redis

prompt '允许远程'

redis_remote(){
read -p "ip port" isremote port
if [ -n $isremote ]
then
ln -s /etc/init.d/redis_$port redis
sed -i 's#bind 127.0.0.1#bind '$isremote'#g' /etc/redis/$port.conf
fi
}
redis_remote

prompt '设置redis密码'
shezhi_mima(){
read -p "pwd" pwd 
if [ -n $pwd ]
then
sed -i 's%# requirepass foobared%requirepass '$pwd'%g' /etc/redis/$1.conf
fi
}
shezhi_mima 6389

prompt '执行完成'
