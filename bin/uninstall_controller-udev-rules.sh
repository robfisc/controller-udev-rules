#!/usr/bin/env bash

BASE_DIR="/opt/controller-udev-rules"


#
# Remove links into system folders
#

# declare array directories
directories=(
    "/opt/retropie/configs/all/retroarch/autoconfig"
    "/etc/systemd/system"
    "/etc/udev/rules.d")

for directory in ${directories[@]}; do
    find ${directory} -type l -print0 | while IFS= read -r -d '' f; do
        # link points to realpath
        realpath=$(readlink -f "$f")
        if [[ $realpath == *"${BASE_DIR}"* ]]; then
            # realpath is within ${BASE_DIR}
            echo "Removing link '$f'"
            rm -f "$f"
        fi
    done
done


#
# base
#

echo "Removing base directory '${BASE_DIR}'"
rm -r "${BASE_DIR}"
