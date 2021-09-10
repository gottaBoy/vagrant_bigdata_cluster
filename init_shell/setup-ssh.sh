#!/bin/bash

[ ! -f /home/vagrant/.ssh/id_rsa.pub ] && ssh-keygen -t rsa -q -f /home/vagrant/.ssh/id_rsa -P ''

for ip in `cat /etc/hosts|grep -vE localhost | awk '{print $2}'`; do
    port="22"
    user="vagrant"
    pass="vagrant"
    echo "========正在提交主机IP为：${ip}免登录========"
    expect -c "
        set timeout 5;
        spawn ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub ${user}@${ip} -p ${port};
        expect {
            \"*assword\" { send \"${pass}\r\";exp_continue}
            \"yes/no\" { send \"yes\r\"; exp_continue }
            eof {exit 0;}
        }";
    echo "========主机IP为：${ip}免登录执行完成========"
done

