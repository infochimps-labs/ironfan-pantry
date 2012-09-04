name        'kafka_server'
description 'kafka server'

run_list(*%w[
    kafka
    kafka::users
    kafka::directories
    kafka::install_from_release
    kafka::server
])
