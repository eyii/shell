#! /bin/bash
nginx_default_conf='/etc/nginx/conf.d/default.conf'
keepalived_conf='/etc/keepalived/keepalived.conf'
nginx_check_sh='/etc/keepalived/nginx_check.sh'
INTERFACE_NAME=$(ifconfig |awk -F: NR==1'{print $1}');
virtual_ipaddress='192.168.172.131/24'
PHP_VERSION='5.6.12'
nginx_version='7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm'
master_ip='192.168.172.130'
slave_ip='192.168.172.132'
web_ip_1='192.168.172.130:80;'
web_ip_2='192.168.172.132:80;'
prompt(){
    read -p "请回车==============开始=======$1"
    CURRENT_PATH=$(pwd);
    echo "当前路径为==========$CURRENT_PATH"
    history -c
    unset CURRENT_PATH;
    clear
}

prompt 'centos7.1实现nginx+keepalived 负载均衡+高可用
http://blog.csdn.net/zhang_h_a/article/details/54315142'

web_ip_1='192.168.172.130:80;'
web_ip_2='192.168.172.130:80;'
function install_keepalived(){
yum  install -y keepalived
}


function install_make(){
prompt '1安装gcc automake autoconf libtool make：'
yum -y install gcc  gcc-c++  make  automake  autoconf  libtool  pcre  pcre-devel  zlib  zlib-devel openssl openssl-devel
yum -y install wget
firewall-cmd --zone=public --add-port=81/tcp --permanent
list=''
}

function open_port(){
list="80 112"
for i in ${list}; do firewall-cmd --zone=public --add-port=${i}/tcp --permanent; done
systemctl restart firewalld
}

function cnf_nginx(){
cp $nginx_default_conf ${nginx_default_conf}'.bak'
rm -f $nginx_default_conf
cat >>$nginx_default_conf  <<EOF
    upstream web {
    ip_hash;
     server ${web_ip_1}
     server ${web_ip_2}
    }
     server {
         listen 80;
         index index.php index.html index.htm;
         location / {
         proxy_pass http://web;
         proxy_set_header X-Real-IP \$remote_addr;
         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }
EOF
}

#install_nginx $nginx_version
function install_nginx(){
#yum -y install epel-release
install_make
sudo rpm -Uvh http://nginx.org/packages/centos/${1}
sudo yum install -y nginx
cnf_nginx
systemctl enable nginx
systemctl start nginx
netstat -ano|grep 80
}

function cnf_nginx_check_sh(){
rm -f $nginx_check_sh
cat >>$nginx_check_sh <<EOF
#!/bin/bash
A=\`ps -C nginx --no-header |wc -l\`     
if [ \$A -eq 0 ];then                                      
   systemctl start nginx
  sleep 2
 if [ \`ps -C nginx --no-header |wc -l\` -eq 0 ];then
  systemctl stop keepalived
   fi
fi
EOF
}

#$1=keepalived_ip ${2}=master/MASTER $3=priority/100 /99  ${4}=nopreempt/''
function cnf_keepalived(){
install_keepalived
cp $keepalived_conf $keepalived_conf'.bak'
rm -f $keepalived_conf
cat >>$keepalived_conf <<EOF
    global_defs {
       router_id ${2}
    }
    vrrp_script chk_nginx {
        script "/etc/keepalived/nginx_check.sh"
        interval 2
        weight -20
    }
    vrrp_instance VI_1 {
        state ${2}
        interface ${INTERFACE_NAME}
        virtual_router_id 51
        mcast_src_ip ${1}
        priority ${3}
        ${4}
        advert_int 1
        authentication {
            auth_type PASS
            auth_pass 1111
        }
        track_script {
            chk_nginx
         }
        virtual_ipaddress {
            ${virtual_ipaddress}
         }
     }
EOF
cnf_nginx_check_sh
systemctl enable keepalived
systemctl start keepalived
systemctl status keepalived
}

function cnf_keepalived_02(){
cp $keepalived_conf $keepalived_conf'.bak'
rm -f $keepalived_conf
cat >>$keepalived_conf <<EOF
global_defs {
   notification_email {
     example@163.com
   }
   notification_email_from  example@example.com
   smtp_server 127.0.0.1
   smtp_connect_timeout 30
   router_id MYSQL_HA
}
vrrp_instance VI_1 {
    state BACKUP
    interface eth1
    virtual_router_id 50
    nopreempt                   #当主down时，备接管，主恢复，不自动接管
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        ahth_pass 123
    }
    virtual_ipaddress {
        ${virtual_ipaddress}          #虚拟IP地址
    }
}
virtual_server ${virtual_ipaddress} 3306 {        
    delay_loop 6
#    lb_algo rr 
#    lb_kind NAT
    persistence_timeout 50
    protocol TCP
    real_server ${1} 3306 {       #监控本机3306端口
        weight 1
        notify_down /etc/keepalived/kill_keepalived.sh   #检测3306端口为down状态就执行此脚本（只有keepalived关闭，VIP才漂移 ） 
        TCP_CHECK {         #健康状态检测方式，可针对业务需求调整（TTP_GET|SSL_GET|TCP_CHECK|SMTP_CHECK|MISC_CHECK）
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
        }
    }
}
EOF
}
function install_httpd(){
yum install httpd -y
systemctl enable httpd
systemctl start httpd
systemctl status httpd
}

function add_log(){
sed -i '14 s#KEEPALIVED_OPTIONS="-D"#KEEPALIVED_OPTIONS="-D -d -S 0"#g' /etc/sysconfig/keepalived
cat /etc/sysconfig/keepalived
}


function main(){
		read -p '
		1===master
		2===slave
		3===web_server
		4===add_log
		' number
		case ${number} in
            1)
            install_nginx {$nginx_version,}
			cnf_keepalived {${master_ip},'MASTER',100,''};;
            2)
            install_nginx {$nginx_version,}
			cnf_keepalived {${slave_ip},'BACKUP',90,'nopreempt'};;
           3)
		    install_httpd;;
			4)
			add_log
	   esac
}
main