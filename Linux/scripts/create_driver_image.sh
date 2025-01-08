#!/bin/bash
set -e

NVIDIA_VERSION=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)
DISK_IMAGE="$(pwd)/wsl.img"

mkdir -p /tmp/wsl_img

CREATE_IMAGE=0
if [ -f "${DISK_IMAGE}" ]; then
    echo "Disk Image exists, checking if update is required"
    if  mountpoint -q "/tmp/wsl_img" ; then
        echo "Image mounted"
    else
        echo "Mouting ${DISK_IMAGE}"
        mount -t auto -o loop wsl.img /tmp/wsl_img || CREATE_IMAGE=1
    fi
    if [ $CREATE_IMAGE -eq 0 ]; then
        touch /tmp/wsl_img/driver_version
        NVIDIA_VERSION_CURRENT=$(cat /tmp/wsl_img/driver_version 2> /dev/null)
        if [ "${NVIDIA_VERSION}" != "${NVIDIA_VERSION_CURRENT}" ]; then
            echo "WSL Drivers need to be updated."
            CREATE_IMAGE=1
        else
            echo "WSL Drivers already at version ${NVIDIA_VERSION}"
        fi
        umount /tmp/wsl_img
    fi
else
  CREATE_IMAGE=1
fi

if [ ${CREATE_IMAGE} -eq 1 ]; then
    if [ -f "${DISK_IMAGE}" ]; then
        echo "Delete old disk image"
        rm -f "${DISK_IMAGE}"
    fi
    echo "Calculate required space for driver"
    WSL_SIZE=$(du -s /usr/lib/wsl | awk '{print $1}')
    EXTRA_SIZE_MB=10
    let DD_COUNT=(WSL_SIZE/1000)+EXTRA_SIZE_MB
    echo "Create new disk image"
    dd if=/dev/zero of=wsl.img bs=1M count=${DD_COUNT} status=progress
    mkfs -t ext4 -L WSL_DRIVER wsl.img
    echo "Mount disk image"
    mount -t auto -o loop wsl.img /tmp/wsl_img
    echo "Copy install script"
    cp scripts/install_update_wsl_driver.sh /tmp/wsl_img
    chown 0:0 /tmp/wsl_img/*.sh
    chmod +x /tmp/wsl_img/*.sh
    echo "Create driver tarball"
    tar -C /usr/lib -czf /tmp/wsl_img/wsl.tgz wsl
    echo "Write driver version"
    echo "${NVIDIA_VERSION}" > /tmp/wsl_img/driver_version
    echo "Unmount image"
    umount /tmp/wsl_img
fi
