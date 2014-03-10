#!/bin/sh
hostsfile="/etc/hosts"
# Bail out if the file is already updated
grep $1 $hostsfile && exit 0
MASTERIP=`dig +short $1`
echo "#Updated at `date`" >> $hostsfile
echo $MASTERIP $1 >> $hostsfile
