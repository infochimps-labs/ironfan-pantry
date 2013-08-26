runit_service "hue"

announce(:hadoop, :hue, {
  ports: {
    ui: {
      port:     node[:hadoop][:hue][:port],
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
      path: File.join(node[:hadoop][:log_dir], 'hue')
    }
  }
})
         
