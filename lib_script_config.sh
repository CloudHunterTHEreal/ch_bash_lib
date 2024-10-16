#!/usr/bin/env bash
###
#
# TODO
# 1. Solve space containing string values problem
# 2. Script exit code correct managing
# 3.Optimize log and error file storage politic feature.
# 4. Add more compact version to the repo (useful?)
# 5. Add silent (? default) mode - without work and error logging in files
#
###

function script_help {
###
#
# Prep and echo help 
#
# Await argument = script running path ($1)
#
###
	echo -e "Get script configuration from ./[scriptname].conf\n\nUsage:\n-----"
	echo "Inside master script:"
 	echo "..."
 	echo "source ./lib_script_config $1"
  	echo "get_config $1"
	echo "..."
	echo "Config notes type format:"
	echo 'config[keyname]=value'
	echo "..."
	echo 'Config option note storing format:'
 	echo 'option_name{ }={ }(num_value | "string_value")'
	echo 'WARNING! Not use spaces inside string values YET!'
}

function script_files_prepare(){
###
#
# Check config file exists, create empty log and error files
#   If no config file exists, create new empty one.
#
###
    local config_file="$1"
    local err_file="$2"
    local log_file="$3"

    # echo "Inside file_prep: conf: $config_file err: $err_file log: $log_file"

    if [ ! -f "$config_file" ]
        then
            echo "[!] Config file not found! Create new empty $config_file" >> "$err_file"
            # touch "$config_file" 2> "$err_file"
            # if [ "$?" != 0 ]
			if ! touch "$config_file" 2> "$err_file"
            then
                echo '[!] Can`t to create new config file: '"$config_file"', script halted.'
                return 1
            else
                echo "Create empty config file: $config_file" >> "$log_file"
            fi
    else
        # echo "Present config file: $log_file"
        return 0
    fi
}

###
#
# MAIN CODE PART
#
###

# TODO Add CL options features
if [ -n "$1" ]; then
	config_dirname="$1"
#	echo "Config filename = >$config_basename<"
else
	# Use system var BASH_SOURCE
	config_dirname="$(dirname $BASH_SOURCE)"
	echo "Config path is \"$config_dirname\""
	echo "Script filename is \"$(basename $BASH_SOURCE)\""
	echo "No extention scriptname is ${config_dirname}" 
fi

# echo "Parsing config for $config_basename"
script_base_path='./'
config_file_extention='.conf'
log_script_extention=".log"
error_script_extention=".err"
script_noextention_basename="${config_basename%.*}"

log_fullpath="$script_base_path""$script_noextention_basename""$log_script_extention"
echo -e "Script config parsing log info:\nStart date: $(date)\n" > "$log_fullpath"

error_fullpath="$script_base_path""$script_noextention_basename""$error_script_extention"
echo -e "Error log file.\nStart date: $(date)\n" > "$error_fullpath"

config_fullpath="$script_base_path""$script_noextention_basename""$config_file_extention"

script_files_prepare "$config_fullpath" "$error_fullpath" "$log_fullpath"

# TODO Awful code part, fix it!
case "$1" in
 -h) script_help config_basename
			return 1
			;;
		*) parent_script="$0"
			;;
esac

function parse_config_option() {
###
#
# Parse "option_name{ }[=]{ }["]option_value["]" -like config note string to [key] and [value]
#       "=" - delimiter between option_name and option_value
#       <space> dropping set here to compatible with "key = value" -like format (f.e. TOML)
#
# Using: parse_config_option "$config_file_line"
# Result: add / update predefined <config> array note config[key]=value | "value" (in case of string data format)
#
###
        local line="$1"
        if  echo "$line" | grep -F = &>/dev/null
        then
                local key="$(echo "$line" | cut -d '=' -f 1)"  # Get option_name note part (before "=").
                key=`awk '{$1=$1};1' <<< "$key"`  # Drop possible border spaces. (!) Leave set var<-command here.

                local value="$(echo "$line" | cut -d '=' -f 2-)" # Get option_value note part (after "=").
                value=`awk '{$1=$1};1' <<< "$value"`  # Drop possible border spaces. (!) Leave set var<-command here.

                config["$key"]="$value"  # Set config option note.
		echo "Gets option: $key=$value" >> "$log_fullpath"
	else
		echo "Inside parse_config_option. [!] Some unexpected value: >$line<" >> "$error_fullpath"
		return 1
        fi
	return 0
}

function read_config() {
###
#
# TODO PUT DOCSTRING HERE
#
###
	local config_filename="$1"

	echo "Read config file: \"$config_filename\"" >> "$log_fullpath"
	while read line
	do
		parse_config_option "$line"
	done < "$config_filename"
	return 0
}

# Drop previously state of the config data
# TODO Though about previously array config processing politics

# Drop previously defined / changed array
unset config
# Define new config data array
typeset -A config
echo "Config init values: ${config[@]}" >> "$log_fullpath"

read_config "$config_fullpath"

echo "Config values: ${config[@]}" >> "$log_fullpath"
echo "Gets ${#config[@]} options" >> "$log_fullpath"
