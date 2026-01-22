#buatpartisi baru bebas /dev/sd"apaaja"
fdisk /dev/sdb
 -> ketik "n" #untuknew partition
 -> ketik "p" #untuk tipe primary
 -> ketik "1" #untuk nomor partisi kalua ketik 1 "/dev/sdb1" nantinya
 ->untuk first sector biarkan default 2048 dengancara klik "Enter"
 -> ketik "+3G" #untuk menambhakan sie partisi bebas brpa aja
 ->ketik "w" untuk save 
#cek /dev/sdb1 yang dibuat ada atau tidak
lsblk
#format partisi menjadi ext4
mkfs.ext4 /dev/sdb
#buat folder newbootload baru disimpan di /mnt ->tujuan nya untuk temporary files
mkdir /mnt/newboot
#mounting /dev/sdb1 ke folder /newboot
mount /dev/sdb1 /mnt/newboot/
#copy isi boot saat ini ke boot yang baru
rsync -avxHAX /boot/ /mnt/newboot/
#unmount boot lama
umount /boot
#backup boot lama opsional,terus buat mount point /boot baru hindari rename dengan /bootdiawal 
mv /boot /oldbotload_bckup
chmod -R 000 /oldbotload_bckup
mkdir /boot

#mount partisi boot baru, lalu cek
mount /dev/sdb1 /boot
mount | grep /boot

#cek UUID /dev/sdb1
blkid /dev/sdb1

#copy uuid ke /etc/fstab
vi /etc/fstab
-"#"command UUID lama
-tambahkan UUID /dev/sdb1 di 
-"UUID=3d1c2b7e-12ab-45cc-9001-d3e4f1c22bb4   /boot   ext4   defaults   0  2"
:wq
#test /etc/fstab
mount -a 
mount | grep /boot
*no eror lanjut

#update grub
grub2-mkconfig -o /boot/grub2/grub.cfg
#installgrub ke disk
grub2-install /dev/sda
grub2-install /dev/sdb
