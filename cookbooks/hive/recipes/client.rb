package("hive")

# Hive log storage on a single scratch dir
volume_dirs('hive.server.log') do
  type          :local
  selects       :single
  path          'hadoop/log/hive/server'
  group         'hive'
  mode          "0777"
end
