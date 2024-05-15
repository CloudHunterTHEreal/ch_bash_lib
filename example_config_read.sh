#!/usr/bin/env bash

###
#
# Test run ~/lib/bash/lib_script_config.sh
#
###

source ~/lib/bash/lib_script_config.sh "$BASH_SOURCE"

echo "${#config[@]} values: ${config[@]}"

#echo "num_key=${config[num_key]}"
