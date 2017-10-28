# mkinicpio-archive-tmpfs

# Author
Author: Kamnil Cukrowski
License: Jointly under MIT License and Beerware License

# Description

### help start

```
Download, uncompress file or copy directory contents into tmpfs and boot from it.

Command Line Setup:

    Set root=... to where Your chroot is, if needed.
    Use specific hook (or no hook at all) to mount Your root.
    Set archivetmpfs=... to a path to a directory or file within Your root containing chroot.
    This chroot will be copied to tmpfs and from that tmpfs the boot process will continue.
    This hook will copy whole chroot to tmpfs mounted directory.
    Then the boot process will continue from the tmpfs.
    When omitting archivetmpfs boot command line parameter, will make booting as usual from a root=... device.a

    Supported archivetmpfs parameters:
        - directory
            Will copy all the files from directory into tmpfs dir.
            archivetmpfs=/root/mychroot
        - tar archive file
            Will use command 'tar -a' to unpack the archive into tmpfs dir.
            archivetmpfs=/root/mychroot.tar
        - url link
            Will download the url link and then use 'tar -a' to unpack the file into tmpfs dir.
            archivetmpfs=http://site.net/file.tar.bz2
            archivetmpfs=ftp://site.net/file.tar.gz

   Examples:
     - This kernel line will boot alpine x86_64 copied into tmpfs and downloaded from the network.
       archivetmpfs=http://dl-cdn.alpinelinux.org/alpine/v3.6/releases/x86_64/alpine-minirootfs-3.6.2-x86_64.tar.gz
    
```

### help stop
