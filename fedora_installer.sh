#!/bin/bash


# ****************************** Variables ******************************

GIT_NAME=""
GIT_EMAIL=""
PHP_VERSION="8.1"

# ***********************************************************************

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}


if confirm "Install the minimum set of programs? (y/n)"; then
  	sudo dnf update -y

	sudo dnf install -y libappindicator \
						libappindicator-gtk3 \
						libheif \
						hddtemp \
						gparted \
						gcolor3 \
						transmission \
						gsmartcontrol \
						git \
						htop \
						pass \
						flameshot \
						gnome-shell-extension-freon \
						lm_sensors \
						hddtemp \
						blueman \
						gnome-tweaks \
						curl \
						wget \
						grubby \
						xl2tpd NetworkManager-l2tp \
						NetworkManager-l2tp-gnome \
						openvpn \
						vim neovim \
						tree \
						zsh \
						powerline \
						unrar \
						vlc \
						simplescreenrecorder \
						gnome-common \
						nautilus-devel \
						python3-docutils \
						python3-gobject \
						gnome-extensions-app \
						gnome-screenshot \
						neofetch \
						duf \
						inxi \
						alacritty \
						cargo \
						rust \
						cmake \
						freetype-devel \
						fontconfig-devel \
						libxcb-devel \
						libxkbcommon-devel \
						g++

	sudo sensors-detect
fi


if confirm "Remove Gnome Apps and LibreOffice? (y/n)"; then
	sudo dnf remove -y fedora-chromium-config \
					   gnome-clocks \
					   rhythmbox \
					   cheese \
					   gnome-tour \
					   gnome-contacts \
					   gnome-maps \
					   libreoffice*

	sudo dnf autoremove && sudo dnf clean all
fi


if confirm "Set Git Config (y/n)"; then
	git config --global user.name $GIT_NAME
	git config --global user.email $GIT_EMAIL
	git config --global push.SetupRemote true
fi	


if confirm "Download Nvidia Drivers (y/n)"; then
	sudo dnf install --nogpgcheck https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	sudo dnf update --refresh
	sudo dnf install gcc \
					 kernel-headers \
					 kernel-devel \
					 akmod-nvidia \
					 xorg-x11-drv-nvidia \
					 xorg-x11-drv-nvidia-cuda \
					 xorg-x11-drv-nvidia-libs \
					 xorg-x11-drv-nvidia-power \
					 nvidia-settings \
					 xorg-x11-drv-nvidia-libs.i686

	echo -e "Please wait a couple of minutes for the driver to build..."
	sleep 80
	sudo akmods --force
	sudo dracut --force
	sudo systemctl enable nvidia-{suspend,resume,hibernate}

	if confirm "Restart Your System (Recommended) (y/n)"; then
		sudo reboot
	fi
fi


if confirm "Install Google Chrome? (y/n)"; then
	sudo dnf install -y google-chrome-stable 
fi


if confirm "Install Dropbox? (y/n)"; then
	mkdir ~/.tmp && cd ~/.tmp
	git clone https://github.com/dropbox/nautilus-dropbox.git && cd nautilus-dropbox
	./autogen.sh
	make
	sudo make install
	./dropbox start -i
fi


if confirm "Install Typora? (y/n)"; then
	cd ~/.tmp
	git clone https://github.com/RPM-Outpost/typora.git && cd typora 
	./create-package.sh
fi


if confirm "Install Sublime Text? (y/n)"; then
	sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
	sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo -y
	sudo dnf install -y sublime-text
fi


if confirm "Install Spotify? (RPM) (y/n)"; then
	sudo dnf config-manager --add-repo=https://negativo17.org/repos/fedora-spotify.repo
	sudo dnf install -y spotify-client
fi


if confirm "Install Telegram Desktop? (y/n)"; then
	mkdir ~/.tmp && cd ~/.tmp
	wget -O - https://telegram.org/dl/desktop/linux > tsetup.tar.gz 
	tar -xvJf tsetup.tar.gz
	mv Telegram telegram-desktop
	sudo mv telegram-desktop /opt/
	sudo rm tsetup.tar.gz
	cd /opt/telegram-desktop
	./Telegram
	cd ~
fi


if confirm "Enable Flathub Repositories (y/n)"; then
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi


if confirm "Set Custom Global Keybindings? (y/n)"; then
	gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
	"['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"
	
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'flameshot'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command '/usr/bin/flameshot gui'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 'Print'
	
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Gnome Screenshot'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'gnome-screenshot -c -a -d 2'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Shift>Print'
	
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Terminal'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'gnome-terminal'
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Ctrl><Alt>T'
fi


if confirm "Install Flatpak App (y/n) "; then
	flatpak install -y flathub com.mattjakeman.ExtensionManager \
							   io.dbeaver.DBeaverCommunity \
							   com.discordapp.Discord \
							   com.spotify.Client \
							   com.github.unrud.VideoDownloader \
							   com.mattjakeman.ExtensionManager \
							   org.onlyoffice.desktopeditors \
							   org.gnome.Solanum \
							   com.getpostman.Postman\
							   com.belmoussaoui.Decoder \
							   com.rafaelmardojai.Blanket \
							   com.github.tchx84.Flatseal \
							   org.gnome.gitlab.YaLTeR.VideoTrimmer \
							   com.belmoussaoui.Authenticator \
							   md.obsidian.Obsidian \
							   flatpak install flathub com.obsproject.Studio \
							   com.obsproject.Studio.Plugin.Gstreamer \
							   com.usebottles.bottles \
							   com.simplenote.Simplenote \
							   io.dbeaver.DBeaverCommunity \
							   us.zoom.Zoom \
							   com.github.vikdevelop.timer

		flatpak override com.usebottles.bottles --user --filesystem=xdg-data/applications
fi

# ******************************** Dev ********************************

if confirm "Install Docker (y/n)"; then
	sudo dnf -y install dnf-plugins-core
	sudo dnf config-manager \
    	--add-repo \
    			https://download.docker.com/linux/fedora/docker-ce.repo
    
	sudo dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin
	sudo systemctl start docker
fi

if confirm "Install PHP (y/n)"; then
	#sudo dnf -y install https://rpms.remirepo.net/fedora/remi-release-[FEDORA-VERSION].rpm
	#sudo dnf config-manager --set-enabled remi 
	sudo dnf module enable php:remi-$PHP_VERSION -y

	sudo dnf install php-{bcmath,xdebug,bz2,fpm,cli,common,curl,dom,exif,ftp,gd,gmp,iconv,imagick,intl,json,mbstring,opcache,posix,simplexml,soap,sockets,ssh2,tokenizer,xml,xmlreader,xmlrpc,zip,pdo,pdo_mysql}

	# ************************************
	# sudo nvim /etc/php.d/15-xdebug.ini
	# ************************************
	# zend_extension="/usr/lib64/php/modules/xdebug.so"
    # xdebug.profiler_enable_trigger=1
	# xdebug.remote_enable=1
	# xdebug.remote_host=127.0.0.1
	# xdebug.remote_port=9003
	# xdebug.var_display_max_depth=10
	# xdebug.max_nesting_level=20000000
	# xdebug.remote_autostart=0
	# xdebug.idekey=PHPSTORM
	# xdebug.mode=debug
	# ************************************

	sudo systemctl restart php-fpm
fi

if confirm "Install Nginx (y/n)"; then
	sudo dnf install nginx

	# Enable if server is test
	# sudo semanage permissive -a httpd_t

	sudo firewall-cmd --permanent --add-service=http
	sudo firewall-cmd --permanent --add-service=https
	sudo firewall-cmd --reload
fi

if confirm "Install MySQL (y/n)"; then
	sudo dnf install mysql-server
	systemctl enable --now mariadb.service
fi

exit 1
