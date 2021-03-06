#!/bin/bash

#
# harbian-audit for Debian GNU/Linux 7/8/9/10 or CentOS Hardening
#

#
# 7.4.2 Create /etc/hosts.allow (Not Scored)
#

set -e # One error, it's over
set -u # One variable unset, it's over

HARDENING_LEVEL=3

FILE='/etc/hosts.allow'

# This function will be called if the script status is on enabled / audit mode
audit () {
	is_centos_8
	if [ $FNRET == 0 ]; then
		tcp_wrappers_warn			
		ok "So PASS."
		return 0
	else
    	does_file_exist $FILE
    	if [ $FNRET != 0 ]; then
        	crit "$FILE does not exist"
    	else
        	ok "$FILE exist"
    	fi
	fi
}

# This function will be called if the script status is on enabled mode
apply () {
	is_centos_8
	if [ $FNRET == 0 ]; then
		tcp_wrappers_warn			
		ok "So PASS."
		return 0
	else
    	does_file_exist $FILE
    	if [ $FNRET != 0 ]; then
        	warn "$FILE does not exist, creating it"
        	touch $FILE
        	warn "You may want to fill it with allowed networks"
    	else
        	ok "$FILE exist"
    	fi
	fi
}

# This function will check config parameters required
check_config() {
    :
}

# Source Root Dir Parameter
if [ -r /etc/default/cis-hardening ]; then
    . /etc/default/cis-hardening
fi
if [ -z "$CIS_ROOT_DIR" ]; then
     echo "There is no /etc/default/cis-hardening file nor cis-hardening directory in current environment."
     echo "Cannot source CIS_ROOT_DIR variable, aborting."
    exit 128
fi

# Main function, will call the proper functions given the configuration (audit, enabled, disabled)
if [ -r $CIS_ROOT_DIR/lib/main.sh ]; then
    . $CIS_ROOT_DIR/lib/main.sh
else
    echo "Cannot find main.sh, have you correctly defined your root directory? Current value is $CIS_ROOT_DIR in /etc/default/cis-hardening"
    exit 128
fi
