#!/bin/sh
su root
PHP_VERSION='5.6.12'
prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}
prompt 'CentOS 7安装PHP 5.6.12'
prompt 'http://www.centoscn.com/image-text/config/2015/0905/6123.html'



prompt '1安装libxml2的类库'
install_libxml2(){
yum install -y  libxml2 libxml2-devel  # 就可以解决
}
install_libxml2



prompt'2下载和编译php'
down_php_configure_install(){
wget http://cn2.php.net/distributions/php-$1.tar.gz
mkdir /src
tar -zxvf php-$1.tar.gz  -C /src
cd /src/php-$1/
./configure --help   # 查看配置参数，因为每个版本的配置参数不一样
./configure --prefix=/usr/local/php-$1 --with-config-file-path=/usr/local/php$1/etc --enable-mb --enable-bcmath --enable-mbstring --enable-sockets --with-curl --enable-ftp --enable-sockets --disable-ipv6 --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --enable-gd-native-ttf --with-iconv-t --with-zlib --with-pdo-mysql=mysqlnd --with-mysqli=mysqlnd --with-mysql=mysqlnd --enable-dom --enable-xml --enable-fpm 
./configure --prefix=/usr/local/php-$1 --with-config-file-path=/usr/local/php$1/etc  --enable-bcmath --enable-mbstring --enable-sockets --witrl --enable-ftp --enable-sockets --disable-ipv6 --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --enable-gd-native-ttf --with-iconv-dir= --enabib --with-pdo-mysql=mysqlnd --with-mysqli=mysqlnd --with-mysql=mysqlnd --enable-dom --enable-xml --enable-fpm
 make test
 make && make install
  # 这是个我参考别人写的配置参数，如果有些类库没有，请yum 或者 源码安装   
 }
prompt '#Thank you for using PHP. #出现这个标识语，表示编译成功'
down_php_configure_install 5.6.12


prompt '3配置php的环境变量'
config_php(){
echo "PATH=$PATH:/usr/local/php/bin:/usr/local/php/sbin" >> /etc/profile
souce !$  # 刷新系统环境
}

prompt '复制php.ini和文件'
cp_file(){
cp /src/php-$1/php.ini-production /usr/local/php/etc/php.ini
cp /src/php-5.6.12/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
}

prompt '复制php-fpm.conf'


prompt '执行完成'
