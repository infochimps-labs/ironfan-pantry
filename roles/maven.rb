name 'maven'
description 'Maven.'

run_list *%w[
    java
    maven::config_files
    maven::install_from_package
]
