#!/bin/bash

#
# Copyright (c) 2023, RBLTracker All rights reserved.
#
# Written by Mike Pultz (mike@mikepultz.com)
#
# $Id: check_rbltracker.sh 247 2015-04-04 02:14:15Z mike $
#

#
# the account sid and auth token should be passed as the arguments like:
#
#   ./check_rbltracker.sh <account_sid> <auth_token>
#
api_url="https://api.rbltracker.com/3.0/listings.nagios";
api_account_sid=$1;
api_auth_token=$2;

#
# this script uses curl to make the API request to the RBLTracker system
#
curl="/usr/bin/curl";

#
# validate that we have an account sid and auth token
#
if [ ${#api_account_sid} -le 33 ]; then 
    echo "You must provide your RBLTracker API account SID and auth token.";
    exit;
fi;
if [ ${#api_auth_token} -le 63 ]; then 
    echo "You must provide your RBLTracker API account SID and auth token.";
    exit;
fi;

#
# make the web request and check the output
#
result=`${curl} -s -G ${api_url} -u "${api_account_sid}:${api_auth_token}"`;
case "$result" in
    OK*)
        echo "$result";
        exit 0;
        ;;
    WARNING*)
        echo "$result";
        exit 1;
        ;;
    CRITICAL*)
        echo "$result";
        exit 2;
        ;;
    UNKNOWN*)
        echo "$result";
        exit 3;
        ;;
    *)
        echo "Invalid response from API: $result";
        exit 3;
        ;;
esac;
