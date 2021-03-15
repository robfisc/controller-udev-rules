#!/usr/bin/env bash


#
# Input parameters
#

# 'add' or 'rm'
MODE="$1"

# controller name is same as input device name
CONTROLLER_NAME="$2"


#
# Constants
#
#XBOXDRV="/usr/bin/xboxdrv"
XBOXDRV="/usr/local/src/xboxdrv/xboxdrv"  # compare xboxdrv_fix/xboxdrv_fix.md
BASE_DIR="/opt/controller-udev-rules"
LOGFILE="${BASE_DIR}/log/xboxdrv_init.log"
CONFIG_FILE="${BASE_DIR}/xboxdrv/sn30proplus.xboxdrv"

# optionally, create individual config files for each controller
# CONFIG_FILE="${BASE_DIR}/xboxdrv/${CONTROLLER_NAME}.xboxdrv"

PID_FILE="${BASE_DIR}/lock/${CONTROLLER_NAME}.pid"

#
# Functions
#
adddate() {
    while IFS= read -r line; do
        printf '%s %s\n' "$(date '+%a, %F %T')" "$line";
    done
}

debug () {
   true     # uncomment to disable debug mode
   #false
}


#
# Main
#

if [ "${MODE}" == "add" ]
then
    # --pid-file ${PID_FILE}
    # PID option does not seem to work, maybe only in daemon mode?
    debug && echo "${XBOXDRV} --evdev /dev/input/${CONTROLLER_NAME} --config ${CONFIG_FILE}" | adddate >> ${LOGFILE}
    ${XBOXDRV} --evdev /dev/input/${CONTROLLER_NAME} --config ${CONFIG_FILE} & >> ${LOGFILE}
    echo $! > ${PID_FILE}
    echo "${CONTROLLER_NAME} was connected." | adddate >> ${LOGFILE}


elif [ "${MODE}" == "rm" ]
then

    pid=$(cat ${PID_FILE})
    if [ "x${pid}" != "x" ]
    then
        debug && echo "Stopping ${CONTROLLER_NAME} (PID ${pid})..." | adddate >> ${LOGFILE}
        kill -1 ${pid}
        wait ${pid}
        echo "${CONTROLLER_NAME} (PID ${pid}) was disconnected properly." | adddate >> ${LOGFILE}
    else
        echo "ERROR: Could not disconnect ${CONTROLLER_NAME}. PID (${pid}) not set." | adddate >> ${LOGFILE}
    fi


else
    echo "ERROR: Got unknown argument '${MODE}'." | adddate >> ${LOGFILE}
fi
