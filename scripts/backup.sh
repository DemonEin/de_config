#!/bin/bash

MOUNT_POINT=/media/usb

# backups can overwrite existing backups but that's ok for now
sudo mount UUID=942af958-8d68-4281-a2a0-9afbbff7124d /media/usb \
    && rsync -a --delete --backup-dir=.backup -f'- .backup' ~/archive/ "$MOUNT_POINT"/archive \
    && sudo umount "$MOUNT_POINT"
