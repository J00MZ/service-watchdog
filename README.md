# service-watchdog
Linux 'watchdog' service that monitors the uptime of other Linux services.

The intervals and number of restarts the service will attempt is configurable.

Parameters are managed in config file 'watchdog.cfg' which is the script's only argument

Dependency:

Daemon executable installed on the system: http://www.libslack.org/daemon/


Usage:
Under /home/user place watchdog.sh and watchdog.cfg (make sure watchdog.sh is executable)
Under /etc/init.d place watchdogsd (again, make sure it's executable)

in watchdog.cfg configure your email, which service to monitor, in what intervals to check and how much time between each restart attempt amd how many of those attempts.

Then run:
sudo service watchdogsd start

The current configuration is monitoring sshd
To change the service being monitored just update SERVICE_NAME in watchdog.cfg and run:
sudo service watchdogsd restart

That's it!
