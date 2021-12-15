#!/bin/bash
# at /home/vagrant
if [ "${IS_VAGRANT}" == "true" ];then
    source "/vagrant/vagrant_bigdata_cluster/scripts/common.sh"
else
    source "/home/vagrant/vagrant_bigdata_cluster/scripts/common.sh"
fi
#---basic install---
# -q（不显示安装的过程）
yum install -y -q sshpass
yum install -y -q lrzsz
yum install -y -q expect
yum install -y -q vim-enhanced
yum install -y -q unzip
yum install -y -q zip
yum install -y -q nmap-ncat
yum install -y -q net-tools
yum install -y -q epel-release  
yum install -y -q lsof
yum install -y -q nc
yum install -y -q wget
yum install -y openssl-devel
yum install -y lzop

# git升级
yum remove -y git*
yum install -y https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.7-1.x86_64.rpm
yum install -y git

#---ssh---
mv /home/vagrant/vagrant_bigdata_cluster/resources/sshd_config /etc/ssh/sshd_config
systemctl restart sshd.service

APP_LOG=/opt/module/applog/log/

[ ! -d $INSTALL_PATH ] && mkdir -p $INSTALL_PATH
[ ! -d $DOWNLOAD_PATH ] && mkdir -p $DOWNLOAD_PATH
[ ! -d $INIT_SHELL_BIN ] && mkdir -p $INIT_SHELL_BIN
[ ! -d $APP_LOG ] && mkdir -p $APP_LOG

chown -R vagrant:vagrant $INSTALL_PATH
chown -R vagrant:vagrant $DOWNLOAD_PATH
chown -R vagrant:vagrant $INIT_SHELL_BIN
chown -R vagrant:vagrant $APP_LOG

# 启动elasticsearch需要的设置
# 更改最大文件句柄数和最大线程数限制
echo -e "* soft nofile 65536\n* hard nofile 65536\n* soft nproc 131072\n* hard nproc 131072" >> /etc/security/limits.conf

# CentOS取消SELINUX
#echo -e "SELINUX=disabled" >> /etc/selinux/config
sed -i "s@^SELINUX=.*@SELINUX=disabled@g" /etc/selinux/config
# 虚拟内存扩容
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
