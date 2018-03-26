# service-watchdog
Linux 'watchdog' service that monitors uptime of other Linux system services.  
The service will check and attempt to restart a service if it's down.

The following parameters are configurable via config file `watchdog.cfg`
- Which system service to monitor.
- The email address to notify issues.
- Intervals between checks of a given service.
- Number of restarts to try when service is down.
- Intervals between restarts.

## Dependencies

[Daemon](http://www.libslack.org/daemon/) installed on your system.

## Installation
`git clone git@github.com:J00MZ/service-watchdog.git`  
`cd service-watchdog`  
`chmod +x watchdog.sh watchdogsd`  
`mv watchdog.sh watchdog.cfg /home/user`  
`sudo mv watchdogsd /etc/init.d`  
  
Then run:  
`sudo service watchdogsd start`

## Configuration 
Set the following in `watchdog.cfg` to your desired configuration.  
- **SERVICE_NAME** - *default: **`sshd`** service*
- **CHECK_INTERVAL** - *default: **`60`** seconds between checks*  
- **MAX_ATTEMPTS** - *default: **`5`** restart attempts*
- **STARTUP_INTERVAL** - *default: **`15`** seconds between each restart*
- **ADMIN_EMAIL** - *default: example email*

To save updated changes run:  
`sudo service watchdogsd restart`  

## Logging
Service logs activity to `/var/log/watchdog_check.log`  
This is also configurable in `watchdog.cfg` file
