#!/bin/bash

#
# Append default_ssh_user user to host if none is given,
# so it doesn't ssh as root on deploy.
#

new_args=''
havent_found_user_host=true
for arg in "$@"
do
    if $havent_found_user_host && [[ $arg =~ .+\..+ ]]; then
        havent_found_user_host=false
        if [[ $arg =~ .+@.+ ]] ; then
            new_args="$new_args $arg"
        else
            new_args="$new_args <%= @default_ssh_user %>@$arg"
        fi
    else
        new_args="$new_args $arg"
    fi
done

ssh -o StrictHostKeyChecking=no <%= @private_keys_paths_string %> $new_args