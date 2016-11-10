#!/bin/bash
if [[ $# -lt 1 ]]; then
        echo "Usage: ./watchdog.sh <config_file>"
        echo
        echo "Note: config file expects following format:"
        echo
        echo "SERVICE_NAME=<SERVICE_NAME>"
        echo "CHECK_INTERVAL=<SECONDS>"
        echo "STARTUP_INTERVAL=<SECONDS>"
        echo "MAX_ATTEMPTS=<SECONDS>"
        echo "ADMIN_EMAIL=<EMAIL_ADDRESS>"
        echo "LOG_FILE=<FILE_FULL_PATH>"
        exit 1
fi
CONFIG_FILE=$1
if [[ ! -f ${CONFIG_FILE} ]]; then
        echo "config file does not exist or wrong path supplied"
        exit 1
fi
function log_event()
{
        local msg=$1
        echo "$(date) -:- ${msg}" >> ${LOG_FILE}
}
function email_event()
{
        local subject=$1
        local event_msg=$2
        echo "${event_msg}" | mail -s "${subject}" ${ADMIN_EMAIL}
}
function watcher_loop()
{
        DOWN_MSG="service ${SERVICE_NAME} is down on $(hostname)"
        ATTEMPT_START_MSG="Attempting to start service ${SERVICE_NAME}"
        STARTED_MSG="service ${SERVICE_NAME} has started"
        while(true)
        do
                if [[ ! $(sudo service ${SERVICE_NAME} status) =~ 'is running' ]];then
                        log_event "${DOWN_MSG}"
                        email_event "${DOWN_MSG}" 'you gonna do something about it?'
                        COUNTER=${MAX_ATTEMPTS}
                        CURRENT_ATTEMPT=1
                        until [ ${COUNTER} -eq 0 ]; do
                                if [[ $(sudo service ${SERVICE_NAME} status) =~ 'is running' ]];then
                                        log_event "${STARTED_MSG} on attempt # ${CURRENT_ATTEMPT}"
                                        email_event "${STARTED_MSG} on attempt # ${CURRENT_ATTEMPT}" "I'm sure you're happy..."
                                        break
                                else
                                        log_event "${ATTEMPT_START_MSG}, attempt # ${CURRENT_ATTEMPT}"
                                        sudo service ${SERVICE_NAME} restart > /dev/null
                                fi
                                let COUNTER-=1
                                CURRENT_ATTEMPT=$((${MAX_ATTEMPTS} - ${COUNTER}))
                                sleep ${STARTUP_INTERVAL}
                        done
                        if [[ ${COUNTER} -eq 0 ]] && [[ ! ($(sudo service ${SERVICE_NAME} status) =~ 'is running') ]];then
                                log_event "THIS IS BAD. Could not startup ${SERVICE_NAME} after ${MAX_ATTEMPTS} attempts."
                                email_event "${DOWN_MSG}" "Still down after ${MAX_ATTEMPTS} attempts to start, check server $(hostname)."
                        fi
                else
                        log_event "Service ${SERVICE_NAME} OK"
                fi
                sleep ${CHECK_INTERVAL}
        done
}
# Script functionality starts here
. ${CONFIG_FILE}
log_event "Started watchdog service checker at $(date)"
watcher_loop
log_event "Ended watchdog service checker at $(date)"
