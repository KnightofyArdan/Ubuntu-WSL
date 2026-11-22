#! usr/bin/ env bash

#Update Ubuntu and Install XFCE + xrdp
#Open your Ubuntu WSL terminal and run these two commands to update your system and install the desktop environment

sudo apt update && sudo apt upgrade -y

#install xfce4 desktop envionments
sudo apt install -y xfce4 xfce4-goodies dbus-x11 xrdp

#Configure the xrdp Port and Session
#Change the default xrdp port from 3389 to 3390 (to avoid conflicting with Windows' built-in Remote Desktop) and configure XFCE to launch properly inside the Remote Desktop window without floating over Windows:
bash
sudo sed -i 's/3389/3390/g' /etc/xrdp/xrdp.ini
cat << 'EOF' > ~/.xsession
unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR
unset WAYLAND_DISPLAY
exec dbus-launch --exit-with-session startxfce4
EOF
chmod +x ~/.xsession

sudo tee /etc/xrdp/startwm.sh << 'EOF'
#!/bin/sh
unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR
unset WAYLAND_DISPLAY
exec dbus-launch --exit-with-session startxfce4
EOF
sudo chmod +x /etc/xrdp/startwm.sh

#Start the xrdp Service
#Restart the xrdp service so all configuration changes take effect
sudo systemctl restart xrdp