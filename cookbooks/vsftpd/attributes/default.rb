default[:vsftpd][:user]       = 'ftp'
default[:vsftpd][:group]      = 'ftp'
default[:users ]['ftp'][:uid] = 61022
default[:groups]['ftp'][:gid] = 61022

vsftpd_conf_dir = '/etc/vsftpd'

default[:vsftpd][:home_dir] = nil # set by volume_dirs
default[:vsftpd][:conf_dir] = vsftpd_conf_dir
default[:vsftpd][:log_dir]  = '/var/log/vsftpd'

### RUNTIME OPTIONS
#
default[:vsftpd][:ipaddress] = (node[:cloud] && node[:cloud][:public_ipv4]) || node[:ipaddress]
#
# If enabled, vsftpd will display directory listings with the time in your
# local time zone. The default is to display GMT.
# The times returned by the MDTM FTP command are also affected by this option.
default[:vsftpd][:use_localtime] = false
#
# If enabled, users of the FTP server can be shown messages when they
# first enter a new directory. By default, a directory is scanned for the file
# .message, but that may be overridden with the configuration setting message_file.
default[:vsftpd][:dirmessage_enable] = false
#
# This is the name of the user that is used by vsftpd when it wants
# to be totally unprivileged. Note that this should be a dedicated user,
# rather than nobody. The user nobody tends to be used for rather
# a lot of important things on most machines.
default[:vsftpd][:nopriv_user] = "nobody"
#
# This string is the name of the PAM service vsftpd will use.
default[:vsftpd][:pam_service_name] = "vsftpd"
#
# Like the listen parameter, except vsftpd will listen on an IPv6 socket
# instead of an IPv4 one. This parameter and the listen parameter
# are mutually exclusive.
default[:vsftpd][:listen_ipv6_exclusively] = false
#
# If enabled, vsftpd will try and show session status information in the
# system process listing. In other words, the reported name of the process
# will change to reflect what a vsftpd session is doing (idle, downloading etc).
# You probably want to leave this off for security purposes.
default[:vsftpd][:setproctitle_enable] = false
#
# Set to false if you want to disallow the PASV method of obtaining a data connection.
default[:vsftpd][:pasv] = true
#
# The minium port to allocate for PASV style data connections.
# Can be used to specify a narrow port range to assist firewalling.
default[:vsftpd][:pasv_min_port] = "1024"
#
# The maximum port to allocate for PASV style data connections.
# Can be used to specify a narrow port range to assist firewalling.
default[:vsftpd][:pasv_max_port] = "1048"



### PERMISSIONS
#
# Controls whether anonymous logins are permitted or not.
# If enabled, both the usernames ftp and anonymous are recognised
# as anonymous logins.
default[:vsftpd][:anonymous_enable] = false
#
# Controls whether local logins are permitted or not.
# If enabled, normal user accounts in /etc/passwd (or wherever your PAM config
# references) may be used to log in. This must be enable for any
# non-anonymous login to work, including virtual users
default[:vsftpd][:local_enable] = true
#
# This option represents a directory which vsftpd will try to change into after
# a local (i.e. non-anonymous) login. Failure is silently ignored.
default[:vsftpd][:local_root] = nil
#
# This controls whether any FTP commands which change the filesystem
# are allowed or not. These commands are: STOR, DELE, RNFR, RNTO, MKD,
# RMD, APPE and SITE.
default[:vsftpd][:write_enable] = false
#
# The value that the umask for file creation is set to for local users. NOTE!
# If you want to specify octal values, remember the "0" prefix otherwise the
# value will be treated as a base 10 integer!
default[:vsftpd][:local_umask] = "022"
#
# This option represents a directory  which  vsftpd  will  try  to
# change  into  after  an  anonymous  login.  Failure  is silently
# ignored.
default[:vsftpd][:anon_root] = nil
#
# If set to YES, anonymous users will be permitted to upload files
# under certain conditions. For this to work, the option write_enable
# must be activated, and the anonymous ftp user must have write permission
# on desired upload locations. This setting is also required for
# virtual users to upload; by default, virtual users are treated with
# anonymous (i.e. maximally restricted) privilege.
default[:vsftpd][:anon_upload_enable] = false
#
# If set to YES, anonymous users will be permitted to create new directories
# under certain conditions. For this to work, the option write_enable
# must be activated, and the anonymous ftp user must have write permission
# on the parent directory.
default[:vsftpd][:anon_mkdir_write_enable] = false
#
# If enabled, all anonymously uploaded files will have the ownership changed
# to the user specified in the setting chown_username. This is useful from
# an administrative, and perhaps security, standpoint.
default[:vsftpd][:chown_uploads] = false
#
# This is the name of the user who is given ownership of anonymously
# uploaded files. This option is only relevant if another option,
# chown_uploads, is set.
default[:vsftpd][:chown_username] = "ftp"
#
# When enabled, allows use of the SITE CHMOD command. NOTE! This only applies to
# local users. Anonymous users never get to use SITE CHMOD.
default[:vsftpd][:chmod_enable] = true



### CHROOT OPTIONS
#
# If set to true, local users will be (by default) placed in a chroot() jail
# in their home directory after login.
# NOTE!! THIS OPTION HAS SECURITY IMPLICATIONS, ESPECIALLY IF THE USERS
# have upload permission, or shell access. Only enable if you know
# what you are doing. Note that these security implications are not vsftpd specific.
# They apply to all FTP daemons which offer to put local users in chroot() jails.
default[:vsftpd][:chroot_local_user] = false
#
# If enabled, along with chroot_local_user , then a chroot() jail location may
# be specified on a per-user basis. Each user's jail is derived from their home
# directory string in /etc/passwd. The occurrence of /./ in the home directory
# string denotes that the jail is at that particular location in the path.
default[:vsftpd][:passwd_chroot_enable] = true
#
# If activated, you may provide a list of local users who are placed
# in a chroot() jail in their home directory upon login.
# The meaning is slightly different if chroot_local_user is set to YES.
# In this case, the list becomes a list of users which are NOT to be placed
# in a chroot() jail. By default, the file containing this list is
# /etc/vsftpd.chroot_list, but you may override this with the chroot_list_file setting.
default[:vsftpd][:chroot_list_enable] = false
#
# The actual users
default[:vsftpd][:chroot_users] = []
#
# The option is the name of a file containing a list of local users which
# will be placed in a chroot() jail in their home directory.
# This option is only relevant if the option chroot_list_enable is enabled.
# If the option chroot_local_user is enabled, then the list file becomes a list
# of users to NOT place in a chroot() jail.
default[:vsftpd][:chroot_list_file] = File.join(vsftpd_conf_dir, "chroot.list")



### SSL OPTIONS
#
# If enabled, and vsftpd was compiled against OpenSSL, vsftpd will support
# secure connections via SSL. This applies to the control connection
# (including login) and also data connections. You'll need a client with
# SSL support too.
# NOTE!! Beware enabling this option. Only enable it if you need it.
# vsftpd can make no guarantees about the security of the OpenSSL libraries.
#  By enabling this option, you are declaring that you trust the security
#  of your installed OpenSSL library.
default[:vsftpd][:ssl_enable] = false
#
# If set to yes, all SSL data connections are required to exhibit
# SSL session reuse (which proves that they know the same master secret
# as the control channel). Although this is a secure default, it may break
# many FTP clients, so you may want to disable it.
# For a discussion of the consequences, see
# http://scarybeastsecurity.blogspot.com/2009/02/vsftpd-210-released.html
default[:vsftpd][:require_ssl_reuse] = false

# Set the value of the SSL certificate.  If present, will cause it to
# be written to the `ssl_cert_path`.
#
# Use the following command to generate an SSL certificate:
#
# $  openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout vsftpd.pem -out vsftpd.pem
#
# and then answer the questions.  Pay particular attention to the
# question that asks for your `Common Name (e.g. server FQDN or YOUR
# name)`.  This is the public name the certificate advertises itself
# as having.  It's important that it match the domain name the ftp
# server will ultimately run behind.
#
# FIXME -- replace this with something more secure
default[:vsftpd][:ssl_cert]      = nil

# Path where SSL certificate will be written.  Override to set a
# different (existing) path.
default[:vsftpd][:ssl_cert_path] = nil

# Set the value of the SSL private key.  If present, will cause it to
# be written to the `ssl_private_key_path`.
#
# FIXME -- replace this with something more secure
default[:vsftpd][:ssl_private_key]      = nil

# Path where SSL private key will be written.  Override to set a
# different (existing) path.
default[:vsftpd][:ssl_private_key_path] = nil

#
# This option can be used to select which SSL ciphers vsftpd will allow for
# encrypted SSL connections. See the ciphers man page for further details. Note
# that restricting ciphers can be a useful security precaution as it prevents
# malicious remote parties forcing a cipher which they have found problems with.
default[:vsftpd][:ssl_ciphers] = "DES-CBC3-SHA"
# If enabled, vsftpd will request (but not necessarily require; see require_cert) a
# certificate on incoming SSL connections.  Normally this should not cause any trouble at
# all, but IBM zOS seems to have issues. (New in v2.0.7).
default[:vsftpd][:ssl_request_cert] = true

# Only applies if ssl_enable is activated. If enabled, this option will permit SSL v2
# protocol connections.  TLS v1 connections are preferred.
default[:vsftpd][:ssl_sslv2] = false
# Only applies if ssl_enable is activated. If enabled, this option will permit SSL v3
# protocol connections.  TLS v1 connections are preferred.
default[:vsftpd][:ssl_sslv3] = false
# Only applies if ssl_enable is activated. If enabled, this option will permit TLS v1
# protocol connections.  TLS v1 connections are preferred.
default[:vsftpd][:ssl_tlsv1] = true
# If true, OpenSSL connection diagnostics are dumped to the vsftpd log file.
# (Added in v2.0.6).
default[:vsftpd][:debug_ssl] = false

### LOGGING OPTIONS
#
# If enabled, a log file will be maintained detailling uploads and
# downloads.
default[:vsftpd][:xferlog_enable] = true
#
# If enabled, two log files are generated in parallel, going by default to
# /var/log/xferlog and /var/log/vsftpd.log.  The former is a wu-ftpd style
# transfer log, parseable by standard tools.  The latter is vsftpd's own style
# log.
default[:vsftpd][:dual_log_enable] = false
#
# If enabled, then any log output which would have gone to /var/log/vsftpd.log
# goes to the system log instead.  Logging is done under the FTPD facility.
default[:vsftpd][:syslog_enable] = false
#
#
# If enabled, the transfer log file will be written in standard xferlog format,
# as used by wu-ftpd. This is useful because you can reuse existing
# transfer statistics generators. The default format is more readable, however.
default[:vsftpd][:xferlog_std_format] = false
#
# When enabled, all FTP requests and responses are logged, providing the option
# xferlog_std_format is not enabled. Useful for debugging.
default[:vsftpd][:log_ftp_protocol] = false


### SESSION AND SECURITY OPTIONS
#
# This controls whether PORT style data connections use port 20 (ftp-data)
# on the server machine. For security reasons, some clients may insist
# that this is the case. Conversely, disabling this option enables vsftpd
# to run with slightly less privilege.
default[:vsftpd][:connect_from_port_20] = false
#
# When enabled, a special FTP command known as "async ABOR" will be enabled.
# Only ill advised FTP clients will use this feature.
# Additionally, this feature is awkward to handle, so it is disabled by default.
# Unfortunately, some FTP clients will hang when cancelling a transfer
# unless this feature is available, so you may wish to enable it.
default[:vsftpd][:async_abor_enable] = false
#
# The timeout, in seconds, which is the maximum time a remote client may spend
# between FTP commands. If the timeout triggers, the remote client is kicked off.
default[:vsftpd][:idle_session_timeout] = 600
#
# The timeout, in seconds, which is roughly the maximum time we permit
# data transfers to stall for with no progress. If the timeout triggers,
# the remote client is kicked off.
default[:vsftpd][:data_connection_timeout] = 120
#
# This option can be used to set a pattern for filenames (and directory names etc.)
# which should not be accessible in any way. The affected items are not hidden,
# but any attempt to do anything to them (download, change into directory,
# affect something within directory etc.) will be denied.
default[:vsftpd][:deny_file] = []
#
# If vsftpd is in standalone mode, this is the maximum number of clients
# which may be connected from the same source internet address.
# A client will get an error message if they go over this limit.
default[:vsftpd][:max_per_ip] = 0
#
# If enabled, all user and group information in directory listings will be
# displayed as "ftp".
default[:vsftpd][:hide_ids] = true



### VIRTUAL USER OPTIONS
#
default[:vsftpd][:virtual_users_enable] = false
#
# See the boolean setting guest_enable for a description of what constitutes
# a guest login. This setting is the real username which guest users are mapped to.
default[:vsftpd][:guest_username] = "ftp"
#
# See the boolean setting guest_enable for a description of what constitutes
# a guest login. This setting is the real username which guest users are mapped to.
default[:vsftpd][:guest_group] = "ftp"
#
# If enabled, all non-anonymous logins are classed as "guest" logins.
# A guest login is remapped to the user specified in the guest_username setting.
default[:vsftpd][:guest_enable] = false
#
# This powerful option allows the override of any config option specified in the
# manual page, on a per-user basis. Usage is simple, and is best illustrated
# with an example. If you set user_config_dir to be /etc/vsftpd_user_conf
# and then log on as the user "chris", then vsftpd will apply the settings in the
# file /etc/vsftpd_user_conf/chris for the duration of the session.
# NOTE!! that not all settings are effective on a per-user basis.
# For example, many settings only prior to the user's session being started.
# Examples of settings which will not affect any behviour on a per-user basis
# include listen_address, banner_file, max_per_ip, max_clients, xferlog_file, etc.
default[:vsftpd][:user_config_dir] = File.join(vsftpd_conf_dir, "users")
#
# Where should vsfptd pam.d look for user passwords
default[:vsftpd][:user_passwd_file] = File.join(vsftpd_conf_dir, ".passwd")
#
# If enabled, virtual users will use the same privileges as local users.
# By default, virtual users will use the same privileges as anonymous users,
# which tends to be more restrictive (especially in terms of write access).
default[:vsftpd][:virtual_use_local_privs] = false
#
# This option is useful is conjunction with virtual users. It is used to
# automatically generate a home directory for each virtual user, based on a
# template. For example, if the home directory of the real user specified via
# guest_username is /home/virtual/$USER, and user_sub_token is set to $USER,
# then when virtual user fred logs in, he will end up (usually chroot()'ed) in
# the directory /home/virtual/fred. This option also takes affect if local_root
# contains user_sub_token.
default[:vsftpd][:user_sub_token] = "$USER"
