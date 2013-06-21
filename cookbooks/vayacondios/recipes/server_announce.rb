announce(:vayacondios, :server,
  :ports => {
    :goliath => {
      :port     => node[:vayacondios][:goliath][:port],
      :protocol => 'http'
    },
  },
  :daemons => {
    :goliath => {
      :name => 'ruby',
      :user => node[:vayacondios][:user],
      :cmd  => 'vayacondios'
    }
  },
  :logs => {
    :server => node[:vayacondios][:log_dir]
  }
)
