#!/bin/bash

arch=$(uname -a)
cpu=$(lscpu | grep "CPU(s):" | grep -v "NUMA" | awk '{print $2}')
vcpu=$(cat /proc/cpuinfo | grep processor | wc -l)
ram=$(free -m | grep "Mem" | awk '{print $3}' | tr -d \\n \
	&& echo -n / \
	&& free -m | grep "Mem" | awk '{print $2}' | tr -d \\n \
	&& echo -n "MB(" \
	&& printf %.2f $(free -m | grep "Mem" | awk '{print $3/$2 * 100}' | tr -d \\n) \
	&& echo -n "%)")
	disc=$(df -t ext4 --total -BM | grep "total" | awk '{print $3}' | tr -d \\n | sed 's/.$//' && echo -n "/" && df -t ext4 --total -BG | grep total | awk '{print $2}' | tr -d \\n && echo -n "b(" && printf %s $(df -t ext4 --total -BM |grep "total"|awk '{print $5}' | tr -d \\n) && echo -n ")" )
	cpuu=$(printf %s $(mpstat |grep "all"|awk '{print 100 - $13}') && echo -n "%")
	lastboot=$(who -b | awk '{print $3}' | tr -d \\n && echo -n " " &&  who -b | awk '{print $4}' | tr -d \\m)
if grep -q "/dev/mapper" /etc/fstab
then
    lvm_use="yes"
else
    lvm_use="no"
fi
	connexions_tcp=$(netstat -an | grep tcp | grep ESTABLISHED | wc -l | tr -d \\n && echo " ESTABLISHED")
	user_log=$(users | wc -w)
	network_ip=$(hostname -I | awk '{print $1}' | tr -d \\n && echo -n " (" && /usr/sbin/ifconfig -a | grep ether | grep Ethernet | awk '{print $2}' | tr -d \\n && echo ")")
	sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l | tr -d \\n && echo " cmd")

wall  "
#Architecture: $arch
#CPU pyhsical : $cpu
#vCPU : $vcpu
#Memory Usage: $ram
#Disk Usage: $disc
#Cpu Usage : $cpuu
#Last boot: $lastboot
#LVM use: $lvm_use
#Connexions TCP : $connexions_tcp
#User log: $user_log
#Network: $network_ip
#Sudo : $sudo
"

