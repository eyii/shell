#! /bin/bash
install_zlib(){
	rm -f zlib-$1.tar.gz
	wgetex http://downloads.sourceforge.net/project/libpng/zlib/$1/zlib-$1.tar.gz
	tar zxvf zlib-$1.tar.gz 
	cd zlib-$1
	ruby ./extconf.rb
	./configure --prefix=/usr/local/zlib-$1
	#ismake_test
	make&&make install
}

install_gem_install_redis_gem(){
	rm -f redis-${REDIS_GEM_VERSION}.gem
	prompt "gem install -l ./redis.gem"
	wgetex $1
	gem install -l ./redis-${REDIS_GEM_VERSION}.gem
}

is_down_success(){
	HAVE= grep –c "The file is already fully retrieved" $1
	#'100%'
	echo $HAVE;
}


#修改gem源码 安装redis
install_gem_sources_and_gem_install_redis(){
	prompt "gem sources 下面要等比较久请耐心等待"
	gem sources --remove https://rubygems.org/
	gem sources --a http://gems.github.com
	gem sources --a http://gems.ruby-china.org/
	gem sources -u
	prompt "gem install redis"
	gem install redis
}

install_soft(){
	while true
	do
	prompt "回车安装====$1==="
	apt-get remove --purge -y $1
	apt-get install -y $1
	read -p "是否重新安装1=重新安装 0=否" is_again
	case $is_again in
	1)
	echo '继续'
	;;
	0)
	break
	;;
	esac
	done
}


#安装rubyems
install_rubyems(){
	#install_soft git
	rm -f master
	apt-get install -y ruby
	#prompt "git clone rubygems.git==="
	rm -rf rubygems-master/
	#git clone https://github.com/rubygems/rubygems.git
	wgetex $1
	unzip master
	cd rubygems-master/
	ruby setup.rb
}



#安装ruby
install_ruby(){
	echo '开始安装ruby========================'
	apt-get remove --purge -y ruby
	for((i=0;i<10;i++));do
	if [ ! -e ruby-$1.tar.gz ]; 
	then
	wgetex ftp://ftp.ruby-lang.org/pub/ruby/ruby-$1.tar.gz
	fi
	done
	unset i
	tar zxvf ruby-$1.tar.gz
	cd ruby-$1/
	./configure --prefix=/usr/local/ruby
	ismake_test
	make&&make install
	cp /usr/local/ruby/bin/ruby /usr/local/bin
}


#安装openssl
install_openssl(){
	prompt "正在安装====openssl===="
	rm -f master
	wgetex https://codeload.github.com/openssl/openssl/zip/master
	unzip master
	cd openssl-master/
	./Configure
	./config
	ismake_test
	make&&make install
	#sudo apt-get install -y openssl 
	#sudo apt-get install -y libssl-dev 
	#sudo apt-get install -y libssl0.9.8
}



#安装tcl
install_tcl(){
	rm -f tcl$1-src.tar.gz
	wgetex http://downloads.sourceforge.net/tcl/tcl$1-src.tar.gz  
	tar zxvf tcl$1-src.tar.gz
	cd tcl$1/unix
	configure_extend
	#make test函数
	ismake_test
	make
	make install
}


#安装总
installenv_main_1(){
	#su - root
	rm -rf /opt/log
	mkdir /opt/log
	echo "安装运行环境"
	cd
	uninstall_redis $PORT_FORM $PORT_TO 
	install_soft unzip 
	install_tcl $TCL_VERSION 
	install_ruby $RUBY_VERSION 
	install_zlib $ZLIB_VERSION
	install_rubyems https://codeload.github.com/rubygems/rubygems/zip/master 
	install_soft gem 
	install_gem_sources_and_gem_install_redis 
	#install_gem_install_redis_gem $REDIS_GEM_URL 
}
