# Fix of 60 Second Delay of xboxdrv

xboxdrv has a known issue that runs into a 60 s timeout when using a bluetooth controller. A switch from call of `libusb_handle_events()` to `libusb_handle_events_timeout_completed()` fixes the issue.

References:
 - [Original xboxdrv bug report: The 60 seconds delay #144](https://github.com/xboxdrv/xboxdrv/issues/144)
 - [fix 60 seconds delay #214](https://github.com/xboxdrv/xboxdrv/pull/214)
 - [Link to commit with fix](https://github.com/xboxdrv/xboxdrv/pull/214/commits/7326421eeaadbc2aeb3828628c2e65bb7be323a9)
 - [Link to patch file of commit](https://github.com/xboxdrv/xboxdrv/commit/7326421eeaadbc2aeb3828628c2e65bb7be323a9.patch), which is stored in the file `xboxdrv_60s_fix.diff`.



## Steps to apply patch

Fixing the delay requires to compile xboxdrv from source with the patch applied (on Raspberry Pi).
These steps follow the compile instructions from xboxdrv's [README](https://github.com/xboxdrv/xboxdrv).


Install pre-requisites
```bash

# potentially update cache as needed
sudo apt-get update

sudo apt-get install \
 g++ \
 libboost-dev \
 scons \
 pkg-config \
 libusb-1.0-0-dev \
 git-core \
 libx11-dev \
 libudev-dev \
 x11proto-core-dev \
 libdbus-glib-1-dev
```

Clone xboxdrv repo:
```bash
# maybe adapt permissions
sudo chmod a+w /usr/local/src

cd /usr/local/src
git clone https://github.com/xboxdrv/xboxdrv.git
cd xboxdrv
```

Copy `60s_fix.patch.diff` into xboxdrv source folder.

Apply patch
```bash
patch src/usb_gsource.cpp < 60s_fix.patch.diff
```

Compile

```bash
scons
```

Expected compile time on Raspberry Pi 4 approx. 9 minutes.

Optionally, install and make sure to reference correct xboxrv executable in `bin/xboxdrv_init.sh`.