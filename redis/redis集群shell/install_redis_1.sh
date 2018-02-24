#! /bin/bash
down_and_mov_redis(){
	if [ ! -e $REDIS_HOME/src ] ; then
	cd $REDIS_PARENT
	wgetex http://download.redis.io/releases/redis-$1.tar.gz
	tar zxvf redis-$1.tar.gz
	mv redis-$1 redis
	fi
}
install_redis_1(){
	rm -rf $REDIS_HOME
	if [ ! -e $REDIS_PARENT ] ; then
	mkdir $REDIS_PARENT
	fi
	for((i=0;i<10;i++));do
	down_and_mov_redis $REDIS_VERSION
	done
	unset i
	cd $REDIS_HOME
	echo "redis测试============================很重要"
	ismake_test
	make 
	make install
	mkdir -p $REDIS_HOME/conf
	mkdir -p $REDIS_HOME/log
	mkdir -p $REDIS_HOME/data
}