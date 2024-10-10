#!/usr/bin/bash

echo "Start study script"

if [ $1 ];then
    echo "Non empty \$1 = $1"
else
    script_dir=`dirname $BASH_SOURCE`
    echo "Script dirname is $script_dir"
    script_name=`basename $BASH_SOURCE`
    echo "Script filename is $script_name"
    # echo "Script filename is $(basename $BASH_SOURCE)"
    name_body="${script_name%.*}"
    echo "Name only scriptname is $name_body"
    # echo "Name only scriptname is ${script_name%.*}"
fi

#tst_cmd="ls -lh $1"

#echo "Output $tst_cmd is:"
#echo "$($tst_cmd)"

# Load script config
#
# Request control dir info
#
# Pop prev dir info                                     #
# Log current dur unto file                             # Push current dir info
#
# Free space size dynamic calculation
#
# Case script run mode:
#     guess) Drop enougth oldest file for suport setted free space until next control script run
#     lazy) Goal - free space

# echo "$(date)"
