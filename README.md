> [!WARNING]
> ## This repository has moved!
>
> **rbltracker/nagios** is no longer maintained. The project has moved to a new home under Generator Labs:
>
> ### ➡️ [generator-labs/nagios-plugin](https://github.com/generator-labs/nagios-plugin)
>
> Please update your bookmarks, forks, and any references. All future development,
> issues, and releases will happen in the new repository.

<a href="https://rbltracker.com" target="_blank">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset="https://portal.rbltracker.com/assets/3.14/images/rbltracker_logo_dark.svg" width="400">
        <img src="https://portal.rbltracker.com/assets/3.14/images/rbltracker_logo_light.svg" width="400">
    </picture>
</a>

[Sign up][rbltracker sign up] for a RBLTracker account and visit our [developer site][rbltracker dev site] for even more details.

# RBLTracker Nagios Plugin

This is a very simple Nagios plugin, written in bash, to integrate with the RBLTracker public API. This tool uses the command line `curl` tool to make an HTTPs GET request to a specific Nagios formatted API URL.

This script returns:

* OK when the "total_listed" value is 0.
* CRITICAL when the "total_listed" value does not equal 0.
* UNKNOWN when there is some other error, like an invalid API token.


## Installation

1. Copy `check_rbltracker.sh` into your Nagios plugins directory; this is most likely `/usr/lib/nagios/plugins` or `/usr/lib64/nagios/plugins` depending on your plaform.
```
cp check_rbltracker.sh /usr/lib/nagios/plugins/
```
2. Make sure `check_rbltracker.sh` is executable:
```
chmod +x /usr/lib/nagios/plugins/check_rbltracker.sh
```

## Nagios Configuration

1. Add a new entry in your `commands.cfg` file to reference the check_rbltracker.sh script:
```
    define command{
        command_name    check-rbltracker
        command_line    $USER1$/check_rbltracker.sh $ARG1$ $ARG2$
        }
```
> The arguments to `check_rbltracker.sh` is your RBLTracker account SID and auth token, both available via the RBLTracker web portal @ https://rbltracker.com/

2. Create a new "no ping" host template that does not include a default ping check against the host. Since this is web service, we only want to check the web request, and not ping:
```
    define host{
        name                            noping-host    ; The name of this host template
        notifications_enabled           1       ; Host notifications are enabled
        event_handler_enabled           1       ; Host event handler is enabled
        flap_detection_enabled          1       ; Flap detection is enabled
        failure_prediction_enabled      1       ; Failure prediction is enabled
        process_perf_data               1       ; Process performance data
        retain_status_information       1       ; Retain status information across program restarts
        retain_nonstatus_information    1       ; Retain non-status information across program restarts
        max_check_attempts              10
        check_interval                  5
        notification_interval           0
        notification_period             24x7
        notification_options            d,u,r
        contact_groups                  admins
        register                        0       ; DONT REGISTER THIS DEFINITION - ITS NOT A REAL HOST, JUST A TEMPLATE!
        }
```
3. Create a new host entry for RBLTracker, using this new `noping-host` template:
```
    define host {
        use                     noping-host
        host_name               RBLTracker
        alias                   RBLTracker
        }
```
4. Create a new service entry for this new host, using the new check command, and pass the RBLTracker account SID and auth token as the arguments to the command:
```
    define service {
        use                     local-service
        host_name               RBLTracker
        service_description     RBLTracker Web Service Check
        check_command           check-rbltracker!ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX!0000000000000000000000000000000000000000000000000000000000000000
        }
```
>Remember to replace with ACXX string with your account SID, and the 0000 string with the API token, both available from the RBLTracker portal.

[rbltracker sign up]:   https://portal.rbltracker.com/signup/
[rbltracker dev site]:  https://rbltracker.com/docs/api/
