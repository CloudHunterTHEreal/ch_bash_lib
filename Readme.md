# Naive study and personal useful bash scripts and tools repo.

#### lib_script_config.sh
>Read config data from `scriptname.conf`
>-----
>Options note format is:
>
>    `option_name{ }={ }num_value | "string_value"`
>
>Store parsed data in `config` array (predefined by `typeset -A config`)
>
>Using in scripts:
>Config data read:
>`source lib_script_config.sh "$BASH_SOURCE"`
>
>Config options using in parent scripts:
>`echo "Config option <key> set as key=${config[key]}"`
> 

___
Any advices or comments are welcome!
