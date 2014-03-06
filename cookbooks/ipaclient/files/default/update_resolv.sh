#!/bin/sh
NS0=`dig +short $SERVER0`
NS1=`dig +short $SERVER1`
NS2=`dig +short $SERVER2`
NS3=`dig +short $SERVER3`
SEARCH="dns-search "$DOMAIN
echo "dns-nameservers " $NS0 $NS1 $NS2 $NS3 >> /etc/network/interfaces
echo $SEARCH >> /etc/network/interfaces
# This doesn't work, but should do the right thing at reboot time
#/sbin/resolvconf  -a eth0 <  /etc/network/interfaces 
echo search $DOMAIN >> /etc/resolv.conf
echo nameserver $NS0 $NS1 $NS2 $NS3 >> /etc/resolv.conf
