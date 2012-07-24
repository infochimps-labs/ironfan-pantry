name 'maven'
description 'Maven.'

run_list *%w[
    java
    maven::maven2
    maven::config_files
]
