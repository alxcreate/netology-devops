# Домашнее задание к занятию "3.5. Файловые системы"

> 1. Узнайте о sparse (разряженных) файлах.

Ok.
> 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
 
Нет. Права и атрибуты на все жесткие ссылки на одни и те же данные идентичны. Если изменить права/владельца/атрибуты на одной жесткой ссылке, то можно увидеть изменения по всем ссылкам потому как ссылка идет непосредственно на запись на диске.

> 3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-20.04"
    config.vm.provider :virtualbox do |vb|
    lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
    lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
    vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
    vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
    end
    end
>Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

    vagrant@vagrant:~$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    loop0                       7:0    0 67.2M  1 loop /snap/lxd/21835
    loop1                       7:1    0 43.6M  1 loop /snap/snapd/14978
    loop2                       7:2    0 61.9M  1 loop /snap/core20/1328
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
    sdb                         8:16   0  2.5G  0 disk
    sdc                         8:32   0  2.5G  0 disk

> 4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

    Device       Start     End Sectors  Size Type
    /dev/sdb1     2048 4196351 4194304    2G Linux filesystem
    /dev/sdb2  4196352 5242846 1046495  511M Linux filesystem

> 5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.

    vagrant@vagrant:~$ Syncing disks.vagrant@vagrant:~$ vagrant@vagrant:~$ sudo sfdisk -d /dev/sdb|sudo sfdisk  /dev/sdc --force
    -bash: Syncing: command not found
    Checking that no-one is using this disk right now ... OK
    
    Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: gpt
    Disk identifier: 59C594E0-2311-254F-AAFF-D9FDC1B4A0FB
    
    Old situation:
    
    Device       Start     End Sectors  Size Type
    /dev/sdc1     2048 4196351 4194304    2G Linux filesystem
    /dev/sdc2  4196352 5242846 1046495  511M Linux filesystem
    
    >>> Done.
    
    New situation:
    Disklabel type: gpt
    Disk identifier: 59C594E0-2311-254F-AAFF-D9FDC1B4A0FB
    
    Device       Start     End Sectors  Size Type
    /dev/sdc1     2048 4196351 4194304    2G Linux filesystem
    /dev/sdc2  4196352 5242846 1046495  511M Linux filesystem
    
    The partition table has been altered.
    Calling ioctl() to re-read partition table.
    Syncing disks.

Результат:

    vagrant@vagrant:~$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    loop0                       7:0    0 67.2M  1 loop /snap/lxd/21835
    loop1                       7:1    0 43.6M  1 loop /snap/snapd/14978
    loop2                       7:2    0 61.9M  1 loop /snap/core20/1328
    loop3                       7:3    0 61.9M  1 loop /snap/core20/1518
    loop4                       7:4    0 67.8M  1 loop /snap/lxd/22753
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    └─sdb2                      8:18   0  511M  0 part
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    └─sdc2                      8:34   0  511M  0 part

> 6. Соберите mdadm RAID1 на паре разделов 2 Гб.

    vagrant@vagrant:~$ sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
    mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
    Continue creating array? y
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.

    vagrant@vagrant:~$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 67.2M  1 loop  /snap/lxd/21835
    loop1                       7:1    0 43.6M  1 loop  /snap/snapd/14978
    loop2                       7:2    0 61.9M  1 loop  /snap/core20/1328
    loop3                       7:3    0 61.9M  1 loop  /snap/core20/1518
    loop4                       7:4    0 67.8M  1 loop  /snap/lxd/22753
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part  /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    └─sdb2                      8:18   0  511M  0 part
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    └─sdc2                      8:34   0  511M  0 part

> 7. Соберите mdadm RAID0 на второй паре маленьких разделов.

    vagrant@vagrant:~$ sudo mdadm --create /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md1 started.

    vagrant@vagrant:~$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 67.2M  1 loop  /snap/lxd/21835
    loop1                       7:1    0 43.6M  1 loop  /snap/snapd/14978
    loop2                       7:2    0 61.9M  1 loop  /snap/core20/1328
    loop3                       7:3    0 61.9M  1 loop  /snap/core20/1518
    loop4                       7:4    0 67.8M  1 loop  /snap/lxd/22753
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part  /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    └─sdb2                      8:18   0  511M  0 part
      └─md1                     9:1    0 1017M  0 raid0
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    └─sdc2                      8:34   0  511M  0 part
      └─md1                     9:1    0 1017M  0 raid0

> 8. Создайте 2 независимых PV на получившихся md-устройствах.

    vagrant@vagrant:~$ sudo pvcreate /dev/md0
    Physical volume "/dev/md0" successfully created.

    vagrant@vagrant:~$ sudo pvcreate /dev/md1
    Physical volume "/dev/md1" successfully created.

Результат: 

    vagrant@vagrant:~$ sudo pvdisplay
    --- Physical volume ---
    PV Name               /dev/sda3
    VG Name               ubuntu-vg
    PV Size               <62.50 GiB / not usable 0
    Allocatable           yes
    PE Size               4.00 MiB
    Total PE              15999
    Free PE               8000
    Allocated PE          7999
    PV UUID               x7S6t2-at3n-E9kU-cz28-gAH3-QU9H-vyVuNf
    
    "/dev/md0" is a new physical volume of "<2.00 GiB"
    --- NEW Physical volume ---
    PV Name               /dev/md0
    VG Name
    PV Size               <2.00 GiB
    Allocatable           NO
    PE Size               0
    Total PE              0
    Free PE               0
    Allocated PE          0
    PV UUID               qm2Adi-vX1U-ngG9-hlI1-pmBB-8uVe-OjXSlX

    "/dev/md1" is a new physical volume of "1017.00 MiB"
    --- NEW Physical volume ---
    PV Name               /dev/md1
    VG Name
    PV Size               1017.00 MiB
    Allocatable           NO
    PE Size               0
    Total PE              0
    Free PE               0
    Allocated PE          0
    PV UUID               SJ7gGx-MFEd-0qFV-68F0-FQye-CqeG-yct0hN

> 9. Создайте общую volume-group на этих двух PV.

    vagrant@vagrant:~$ sudo vgcreate vg0 /dev/md0 /dev/md1
    Volume group "vg0" successfully created

Результат:

    vagrant@vagrant:~$ sudo vgdisplay
    --- Volume group ---
    VG Name               ubuntu-vg
    System ID
    Format                lvm2
    Metadata Areas        1
    Metadata Sequence No  2
    VG Access             read/write
    VG Status             resizable
    MAX LV                0
    Cur LV                1
    Open LV               1
    Max PV                0
    Cur PV                1
    Act PV                1
    VG Size               <62.50 GiB
    PE Size               4.00 MiB
    Total PE              15999
    Alloc PE / Size       7999 / <31.25 GiB
    Free  PE / Size       8000 / 31.25 GiB
    VG UUID               4HbbNB-kISH-fXeQ-qzbV-XeNd-At34-cCUUuJ
    
    --- Volume group ---
    VG Name               vg0
    System ID
    Format                lvm2
    Metadata Areas        2
    Metadata Sequence No  1
    VG Access             read/write
    VG Status             resizable
    MAX LV                0
    Cur LV                0
    Open LV               0
    Max PV                0
    Cur PV                2
    Act PV                2
    VG Size               <2.99 GiB
    PE Size               4.00 MiB
    Total PE              765
    Alloc PE / Size       0 / 0
    Free  PE / Size       765 / <2.99 GiB
    VG UUID               BgJ9s1-DJF1-g0ds-37yt-Q73p-grkv-QvKNvd

> 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

    vagrant@vagrant:~$ sudo lvcreate vg0 /dev/md0 -L 100M
    Logical volume "lvol0" created.

Результат:

    vagrant@vagrant:~$ sudo lvdisplay
    --- Logical volume ---
    LV Path                /dev/ubuntu-vg/ubuntu-lv
    LV Name                ubuntu-lv
    VG Name                ubuntu-vg
    LV UUID                mJ8K7e-F4uw-o8Sx-iwt0-JfLQ-Dpoh-E7lSU1
    LV Write Access        read/write
    LV Creation host, time ubuntu-server, 2022-06-07 11:41:15 +0000
    LV Status              available
    # open                 1
    LV Size                <31.25 GiB
    Current LE             7999
    Segments               1
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     256
    Block device           253:0

    --- Logical volume ---
    LV Path                /dev/vg0/lvol0
    LV Name                lvol0
    VG Name                vg0
    LV UUID                FHBzwf-7WCu-hbZ1-TRmA-JwUH-ncvy-RKzU1n
    LV Write Access        read/write
    LV Creation host, time vagrant, 2022-07-07 12:47:05 +0000
    LV Status              available
    # open                 0
    LV Size                100.00 MiB
    Current LE             25
    Segments               1
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     256
    Block device           253:1

> 11. Создайте mkfs.ext4 ФС на получившемся LV.

    vagrant@vagrant:~$ sudo mkfs.ext4 /dev/vg0/lvol0
    mke2fs 1.45.5 (07-Jan-2020)
    Creating filesystem with 25600 4k blocks and 25600 inodes
    
    Allocating group tables: done
    Writing inode tables: done
    Creating journal (1024 blocks): done
    Writing superblocks and filesystem accounting information: done

> 12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.

    vagrant@vagrant:~$ sudo mount /dev/vg0/lvol0 /home/vagrant/lvol0

> 13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.

    vagrant@vagrant:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /home/vagrant/lvol0/test.gz
    --2022-07-07 12:54:26--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
    Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
    Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 23823774 (23M) [application/octet-stream]
    Saving to: ‘/home/vagrant/lvol0/test.gz’
    
    /home/vagrant/lvol0/test.gz                  100%[==============================================================================================>]  22.72M  26.1MB/s    in 0.9s
    
    2022-07-07 12:54:27 (26.1 MB/s) - ‘/home/vagrant/lvol0/test.gz’ saved [23823774/23823774]
    
    vagrant@vagrant:~$ ls lvol0
    lost+found  test.gz

> 14. Прикрепите вывод lsblk.

    vagrant@vagrant:~$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 67.2M  1 loop  /snap/lxd/21835
    loop1                       7:1    0 43.6M  1 loop  /snap/snapd/14978
    loop2                       7:2    0 61.9M  1 loop  /snap/core20/1328
    loop3                       7:3    0 61.9M  1 loop  /snap/core20/1518
    loop4                       7:4    0 67.8M  1 loop  /snap/lxd/22753
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part  /boot
    └─sda3                      8:3    0 62.5G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    │   └─vg0-lvol0           253:1    0  100M  0 lvm   /home/vagrant/lvol0
    └─sdb2                      8:18   0  511M  0 part
      └─md1                     9:1    0 1017M  0 raid0
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    │   └─vg0-lvol0           253:1    0  100M  0 lvm   /home/vagrant/lvol0
    └─sdc2                      8:34   0  511M  0 part
      └─md1                     9:1    0 1017M  0 raid0

> 15. Протестируйте целостность файла:

    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0

Результат:

    vagrant@vagrant:~$ gzip -t lvol0/test.gz
    vagrant@vagrant:~$ echo $?
    0

> 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

    vagrant@vagrant:~$ sudo pvmove /dev/md0
    /dev/md0: Moved: 40.00%
    /dev/md0: Moved: 100.00%

> 17. Сделайте --fail на устройство в вашем RAID1 md.

    vagrant@vagrant:~$ sudo mdadm /dev/md0 --fail /dev/sdc1
    mdadm: set /dev/sdc1 faulty in /dev/md0

Результат:

    vagrant@vagrant:~$ sudo mdadm -D /dev/md0
    /dev/md0:
    Version : 1.2
    Creation Time : Thu Jul  7 12:33:39 2022
    Raid Level : raid1
    Array Size : 2094080 (2045.00 MiB 2144.34 MB)
    Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
    Raid Devices : 2
    Total Devices : 2
    Persistence : Superblock is persistent
    
           Update Time : Thu Jul  7 13:05:19 2022
                 State : clean, degraded
        Active Devices : 1
    Working Devices : 1
    Failed Devices : 1
    Spare Devices : 0
    
    Consistency Policy : resync
    
                  Name : vagrant:0  (local to host vagrant)
                  UUID : 96cddf89:051db913:d9174b2b:63815f4f
                Events : 19
    
        Number   Major   Minor   RaidDevice State
           0       8       17        0      active sync   /dev/sdb1
           -       0        0        1      removed
    
           1       8       33        -      faulty   /dev/sdc1

> 18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.

    vagrant@vagrant:~$ dmesg | grep md0
    [ 4646.830274] md/raid1:md0: not clean -- starting background reconstruction
    [ 4646.830276] md/raid1:md0: active with 2 out of 2 mirrors
    [ 4646.830299] md0: detected capacity change from 0 to 2144337920
    [ 4646.833545] md: resync of RAID array md0
    [ 4657.126673] md: md0: resync done.
    [ 6546.076677] md/raid1:md0: Disk failure on sdc1, disabling device.
    md/raid1:md0: Operation continuing on 1 devices.

> 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0

Результат:

    vagrant@vagrant:~$ gzip -t lvol0/test.gz
    vagrant@vagrant:~$ echo $?
    0

> 20. Погасите тестовый хост, vagrant destroy.

    PS C:\Users\user\vagrant> vagrant halt
    ==> default: Attempting graceful shutdown of VM...

    PS C:\Users\user\vagrant> vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
    ==> default: Destroying VM and associated drives...