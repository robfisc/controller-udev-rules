# controller-udev-rules
UDEV rules and associated files to use multiple gaming controllers with identical names but different key bindings.

Many game controllers show up under identical names, i.e. "Gamepad" or in case of 8BitDo "Pro Controller". This works fine if the same controller is used more than once. However, it becomes a problem when different types of controllers with identical names are used because key mappings in retropie/retroarch are likely to be in conflict.

To allow using multiple controller types with the same name at the same time, different types of controllers are assigned different names as follows:
An UDEV rule creates a unique device link under `/dev/input/` and calls a system service that starts an instance of xboxdrv. xboxdrv will create a new device interface configured with a different name. To avoid multiple identification of a controller under its original device and the xboddrv device, the original device link's permissions are changed to avoid access by user applications. Setup is done using [Ansible](https://www.ansible.com).

Once the setup procedure is completed, the affected controllers should automatically appear under the names configured in xboxdrv/sn30proplus.xboxdrv when they are connected.

## Setup

Steps
 - Setup public key SSH authentication for host *retropie*.
 - Connect bluetooth controllers on remote host.
 - Optionally, create virtual env and install requirements
    ```bash
    python -m venv env
    source env/bin/activate
    python -m pip install -r requirements.txt
    ```
 - Configure MAC address, i.e. ATTRS{uniq} in `udev/99-controller-udev.rules`
 - Run ansible within virtual env
    ```bash
    ansible-playbook -i retropie, -e "pipelining=True"  -e 'ansible_python_interpreter=/usr/bin/python3' ansible/xboxdrv.yaml
    ```
 - Optionally, compile xboxdrv from source to fix 60 second delay, see [xboxdrv_fix/xboxdrv_fx.md](xboxdrv_fix/xboxdrv_fx.md). Adjust bin/xboxdrv_init.sh to reference correct xboxdrv executable.


## Inspired by
- [Universal Controller Calibration & Mapping Using xboxdrv  - retropie.org](https://retropie.org.uk/docs/Universal-Controller-Calibration-%26-Mapping-Using-xboxdrv/)
- [GitHub: phantom-voltage/xboxdrv-udev-rules](https://github.com/phantom-voltage/xboxdrv-udev-rules)
