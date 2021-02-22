ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime;
hwclock --systohc;
vim /etc/locale.gen;
locale-gen;
echo 'LANG=en_US.UTF-8'  > /etc/locale.conf;
passwd root;
pacman -S intel-ucode;
pacman -S grub efibootmgr;
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB;
grub-mkconfig -o /boot/grub/grub.cfg;
useradd -m -G wheel ljn;
passwd ljn;
vim /etc/sudoers;
vim /etc/pacman.conf;
pacman -Syyu;
pacman -S archlinuxcn-keyring;
pacman -S chromium yay xorg-server xorg-xinit xorg-apps;
pacman -S fcitx5-im fcitx5-rime;
pacman -S feh qv2ray v2ray;
pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel;
pacman -S nvidia lib32-nvidia-utils nvidia-prime numlockx upower electron-netease-cloud-music;
