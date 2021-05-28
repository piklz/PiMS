mkdir /media/usb_EXTDRIVE_1
sudo mount /dev/sda1 /media/usb_EXTDRIVE_1
sudo nano  /etc/fstab 
 - use this and past in next line at end of file replacing your uuids parts numbers from the blkid command earlier:
    -put thia intofsta on last line >  ' PARTUUID=cc594dab-8e57-4e99-b578-bf4379fcf122 /media/usb_EXTDRIVE_1 ext4 auto,rw,noatime 0 2'
