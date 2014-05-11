#!/bin/bash
#
# zabbix_agentd        Startup script for zabbix_agentd.
#
# chkconfig: 2345 12 88
# description: Syslog is the facility by which many daemons use to log \
# messages to various system log files.  It is a good idea to always \
# run zabbix_agentd.
### BEGIN INIT INFO
# Required-Start: $local_fs $network
# Required-Stop: $local_fs $network
# Default-Start:  2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Monitor
# Description: Zabbix_Agentd is a monitoring daemon
### END INIT INFO

# Source function library.
. /etc/init.d/functions

RETVAL=0
PIDFILE=<%= node.zabbix.pid_dir %>/$NAME.pid

prog=zabbix_agentd
exec=/usr/local/bin/$prog
lockfile=/var/lock/subsys/$prog

# Source config
if [ -f /etc/sysconfig/$prog ] ; then
    . /etc/sysconfig/$prog
fi

start() {
        [ -x $exec ] || exit 5

        umask 077

        echo -n $"Starting zabbix agent: "
        daemon --pidfile="$PIDFILE" $exec -- -c <%= node.zabbix.conf_dir %>/zabbix_agentd.conf
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && touch $lockfile
        return $RETVAL
}
stop() {
        echo -n $"Shutting down system logger: "
        killproc -p "$PIDFILE" $exec
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && rm -f $lockfile
        return $RETVAL
}
rhstatus() {
        status -p "$PIDFILE" -l $prog $exec
}
restart() {
        stop
        start
}

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        restart
        ;;
  reload)
        exit 3
        ;;
  force-reload)
        restart
        ;;
  status)
        rhstatus
        ;;
  condrestart|try-restart)
        rhstatus >/dev/null 2>&1 || exit 0
        restart
        ;;
  *)
        echo $"Usage: $0 {start|stop|restart|condrestart|try-restart|reload|force-reload|status}"
        exit 3
esac

exit $?
