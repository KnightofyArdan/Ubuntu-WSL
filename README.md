## Ubuntu WSL
1. Enable Hyper-V to run Virtual Machine on a windows hardware device
* On your Windows, klick Start and type **Turn Windows Feature On or Off**
* Check **Hyper-V** and **Virtual Machine Platform**
2. Install WSA on Microsoft PowerShell
  Install WSL
  ```
  WSL --install
  ```
  Install Ubuntu
  ```
  WSL --install -d Ubuntu-26.04
  ```
3. Update Ubuntu and Install XFCE + xrdp
    Open your Ubuntu WSL terminal and run these two commands to update your system and install the desktop environment
```
sudo apt update && sudo apt upgrade -y
sudo apt install -y xfce4 xfce4-goodies dbus-x11 xrdp
```

2. Configure the xrdp Port and Session

Change the default xrdp port from 3389 to 3390 (to avoid conflicting with Windows' built-in Remote Desktop) and configure XFCE to launch properly inside the Remote Desktop window without floating over Windows:
bash
```
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
```
3. Start the xrdp Service

Restart the xrdp service so all configuration changes take effect:
bash
```
sudo systemctl restart xrdp
```

4. Connect in Full Screen from Windows
   Press ``` Win + R ```

1. Press **Win + R** type ```mstsc```
2. Click Show Options at the bottom-left corner of the Remote Desktop window.
3. Go to the Display tab and drag the Display configuration slider all the way to the right (Full Screen).
4. Go back to the General tab, type ```127.0.0.1:3390``` in the Computer box, and click Connect.
5. When the security certificate popup appears, check Don't ask me again for connections to this computer and click Yes.
6. On the xrdp login screen, leave Session set to Xorg, enter your Ubuntu username and password, and click OK.
