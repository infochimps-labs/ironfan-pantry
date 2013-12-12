package("hue")
package("hue-server")

service "hue" do
  action node[:hue][:run_state]
end

announce(:hue, :server, {
  ports: {
    ui: {
      port:     node[:hue][:port],
      protocol: 'http',
    }
  },
  daemons: {
    ui: {
      user: 'root',
      name: 'python2.7',
      cmd:  'hue.*supervisor'
    },
  },
  logs: {
    ui: {
      path: node[:hue][:log_dir]
    }
  }
})
