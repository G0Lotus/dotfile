#!/bin/bash

function archlinuxcn(){

	echo "#0. Enable archlinuxcn and update keyring"
	if [ $(cat /etc/pacman.conf | grep -c archlinuxcn) -eq 0 ]; then
		cat >> /etc/pacman.conf << EOF
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch
EOF
	rm -fr /etc/pacman.d/gnupg
	pacman-key --init
	pacman-key --populate
	iso=$(curl -4 ifconfig.co/country-iso)
	reflector -a 48 -c ${iso} -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
	pacman -Syy archlinuxcn-keyring --noconfirm
fi
}

function timezone(){
	echo "#1. Update Timezone"
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	hwclock --systohc
}

function locale(){
	echo "#2. Update Locale-gen"
	sed -i 's/#en_SG.UTF-8/en_SG.UTF-8/g' /etc/locale.gen
	sed -i 's/#zh_CN.UTF-8/zh_CN.UTF-8/g' /etc/locale.gen
	locale-gen
	echo "LANG=en_SG.UTF-8" > /etc/locale.conf
}

function pre_packages(){
	echo "#3. Install prerequiest packages"
	cat /root/dotfiles/packages/pre.txt | xargs pacman -S --noconfirm
}

function network(){
	echo "#4. Update Network Configuration"
	echo "Archer" > /etc/hostname
	cat > /etc/hosts << EOF
127.0.0.1	localhost
::1		localhost
127.0.1.1	Archer.localdomain	Archer
EOF
}

function root_user(){
	echo "#5. Setup admin password"
	passwd

	echo "#6. Create new user"
	read -p "What is your username:" ${user}
	sed -i "s/# \(%wheel ALL=(ALL) NOPASSWD: ALL\)/\1/g" /etc/sudoers
	useradd -m -G wheel -s /bin/zsh ${user}
	echo "Please enter user:${user}'s password"
	passwd ${user}
}

function grub(){
	echo "#7. Grub"
	echo "Here is your Disk list:"
	fdisk -l | grep -v loop | awk '/Disk \/dev/{sub(":","",$2); print $2}'
	read -p "What is the disk you choose to install ArchLinux System: " disk
	type=$(fdisk -l /dev/sda | awk -F ": " '/type/{print $2}')
	if [[ $type="gpt" ]]; then
		grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
	else
		grub-install --target=i386-pc ${disk}
	fi
	grub-mkconfig -o /boot/grub/grub.cfg
}

######### main run here ##############
archlinuxcn
