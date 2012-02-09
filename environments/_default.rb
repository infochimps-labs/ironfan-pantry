require 'chef/mixin/deep_merge'

# Default attributes to include in every environment
$_default_environment = {
  :discovers => {
    :nfs        => { :server => 'sandbox' },
    :zabbix     => { :server => 'sandbox' },
  },
  :route53 => { :zone => "YOURDOMAIN.com" },
}
