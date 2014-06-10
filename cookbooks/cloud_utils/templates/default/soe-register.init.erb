#!/bin/sh
#
# Registers and Unregisters this machine from a Red Hat subscription
#
# chkconfig: 2345 95 05
# description: This script registers the machine with Red Hat, and unregisters on shutdown

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ ${NETWORKING} = "no" ] && exit 0

LOCKFILE=/var/lock/subsys/soe-register

RETVAL=0

# See how we were called.
case "$1" in
  start)
        if [ $UID -ne 0 ] ; then
            echo "User has insufficient privilege."
            exit 4
        fi
        echo -n "Registering instance: "
	subscription-manager register --user=<%= @user %> --pass=<%= @password %> --auto-attach
	subscription-manager attach --pool=<%= @pool %>
	subscription-manager repos --disable=*
	subscription-manager repos --enable=rhel-6-server-rpms
	subscription-manager repos --enable=rhel-6-server-optional-rpms
	subscription-manager repos --enable=rhel-6-server-supplementary-rpms
	touch $LOCKFILE
	RETVAL=$?
        echo
        ;;
  stop)
	curl 10.0.8.60:8000/foobar
	subscription-manager unregister
	rm -f $LOCKFILE
	RETVAL=$?
        echo
        ;;
  status)
	status soe-register
	RETVAL=$?
	;;
  *)
        echo "Usage: $0 {start|stop|status}"
        exit 2
esac

exit $RETVAL

