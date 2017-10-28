# mkinicpio-archivetmpfs

# Use cases

The primary use for mkinitcpio-archivetmpfs is to enable booting a rootfs image from tmpfs. This is used by me for running failsafe linux in case my primary linux gets non-bootable and for running CPU stressing programs to test overclocking. In any case, if you have a separate partition for boot directory, you may have a prepared, compressed archive with a failsafe rootfs with all needed programs and modules needed to repair Your system. This hooks will run this rootfs from a tmpfs mounted directory (so you may need to have much ram in your system), so this will not touch your root filesystem, so You may proceed with any repairing tools You want. As no filesystems are mounted, this is also perfect for checking system stability, for ex. after heavy overclocking.

# Examples

Following examples were tested on Arch Linux with alpine rootfs.  

## Example setup

Don't run this, it may harm your system. This is just an example, not to be used by copy+paste.
```
# create another copy of kernel
cp -a /boot/vmlinuz-linux /boot/vmlinuz-archivetmpfs

# create new configuration of mkinitcpio.conf with archivetmpfs enabled
cp /etc/mkinitcpio.conf /etc/mkinitcpio.d/archivetmpfs-mkinictpio.conf

# add archivetmpfs to HOOKS in archivetmpfs-mkinitcpio.conf
sed -i -e 's/^HOOKS="\(.*\)"/HOOKS="\1 archivetmpfs"/' /etc/mkinitcpio.d/archivetmpfs-mkinictpio.conf

# create preset for archivetmpfs
cat > /etc/mkinitcpio.d/archivetmpfs.preset <<EOF
# mkinitcpip preset file for the linux package using 'mkinitcpio-archivetmpfs'

ALL_config="/etc/mkinitcpio.d/archivetmpfs-mkinictpio.conf"
ALL_kver="/boot/vmlinuz-archivetmpfs"

PRESETS=(default)

default_image="/boot/initramgs-archivetmpfs.img"

EOF

# generate initcpio
mkinitcpio -p archivetmpfs

# refresh grub, when using grub2 it should automagically pick up /boot/vmlinux-archivetmpfs
grub-mkconfig -o /boot/grub/grub.cfg

# now add archivetmpfs=? line to kernel line arguments in grub.cfg
```

## Compressed archive with rootfs

You may have downloaded alpine image to a file on Your disc.  
To use that, point archivetmpfs argument to the path to that file on disc pointed to by root parameter.
Example:
I have downloaded alpine rootfs into our local disc.
```
curl -o /alpine.tar.gz http://dl-cdn.alpinelinux.org/alpine/v3.6/releases/x86_64/alpine-minirootfs-3.6.2-x86_64.tar.gz
```
Then You need to just add to kernel line parameters:
```
archivetmpfs=/alpine.tar.gz
```
then mkinitcpio-archivetmpfs hook will unpack /alpine.tar.gz contents into tmpfs directory during boot.

## Directory with linux rootfs

You may have your amazing linux rootfs inside /rootfs direcotry on your /dev/sda1 drive.  
For ex. for alpine linux, one could do:  
```
mkdir -p /rootfs
curl http://dl-cdn.alpinelinux.org/alpine/v3.6/releases/x86_64/alpine-minirootfs-3.6.2-x86_64.tar.gz | tar xzfvp - -C /rootfs
```
The mkinitcpio-archivetmpfs hook will copy /rootfs directory contents into tmpfs mounted directory and after that it will boot from that tmpfs directory.  
To do that, just add to kernel command line:  
```
archivetmpfs=/rootfs
```

After that You may want to boot natively this alpine linux.  
mkinitcpio-archivetmpfs will copy /rootfs directory content into tmpfs mounted directory.  
And then, it will boot from that tmpfs directory.  

## Url

To download a rootfs from url:
- you need to make sure to have network enabled and configured in Your initcpio.
- you need to add "curl" program to your initcpio (modify BINARIES= variable inside mkinitcpio-archive.conf).

After that, to run alpine linux natively on Your computer from tmpfs, add the following to the kernel command line arguments:
```
archivetmpfs=http://dl-cdn.alpinelinux.org/alpine/v3.6/releases/x86_64/alpine-minirootfs-3.6.2-x86_64.tar.gz
```
Or Arch Linux?
```
archivetmpfs=http://mirror.rackspace.com/archlinux/iso/2017.10.01/archlinux-bootstrap-2017.10.01-x86_64.tar.gz
```
The mkinitcpio-archivetmpfs script will download specified file, unpack it to tmpfs directory, chroot to that tmpfs directory and run init script from it.
The root=... parameter may be omitted when using network link for archivetmpfs, as root device is not needed (archive is downloaded directly into tmpfs).

# Description

Following help is copied from install script.

###### help start

```
Download, uncompress file or copy directory contents into tmpfs and boot from it.

Command Line Setup:

    Set root=... to where Your rootfs is, if needed.
    Use specific hook (or no hook at all) to mount Your root.
    Set archivetmpfs=... to a path to a directory or file within Your root containing rootfs.
    This rootfs will be copied to tmpfs and from that tmpfs the boot process will continue.
    This hook will copy whole rootfs to tmpfs mounted directory.
    Then the boot process will continue from the tmpfs.
    When omitting archivetmpfs boot command line parameter, will make booting as usual from a root=... device.a


Supported archivetmpfs parameters:
    - directory
      Will copy all the files from directory into tmpfs dir.
      archivetmpfs=/home/myrootfs
    - tar archive file
      Will use command 'tar -a' to unpack the archive into tmpfs dir.
      archivetmpfs=/home/myrootfs.tar
    - url link
      Will download the url link and then use 'tar -a' to unpack the file into tmpfs dir.
      archivetmpfs=http://site.net/file.tar.bz2
      archivetmpfs=ftp://site.net/file.tar.gz

Examples:
    - This kernel line will boot alpine x86_64 from tmpfs
      archivetmpfs=http://dl-cdn.alpinelinux.org/alpine/v3.6/releases/x86_64/alpine-minirootfs-3.6.2-x86_64.tar.gz
    
```
###### help stop



# Author
Author: Kamil Cukrowski
License: Jointly under MIT License and Beerware License

