name        'kafka_client'
description 'kafka client'

run_list(*%w[
    kafka
    kafka::users
    kafka::directories
    kafka::install_from_release
])
