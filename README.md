# Ubuntu-WSL

How to Set Up a Full Desktop Environment on Ubuntu WSL2


1. Update Ubuntu and Install XFCE + xrdp

Open your Ubuntu WSL terminal and run these two commands to update your system and install the desktop environment, D-Bus utilities, and the Remote Desktop server:
bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y xfce4 xfce4-goodies dbus-x11 xrdp
Use code with caution.
(If prompted to choose a default display manager during installation, select lightdm and press Enter.)

2. Configure the xrdp Port and Session

Change the default xrdp port from 3389 to 3390 (to avoid conflicting with Windows' built-in Remote Desktop) and configure XFCE to launch properly inside the Remote Desktop window without floating over Windows:
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
Use code with caution.

3. Start the xrdp Service

Restart the xrdp service so all configuration changes take effect:
bash
sudo systemctl restart xrdp
Use code with caution.

4. Connect in Full Screen from Windows

1. Press Win + R on your keyboard, type mstsc, and press Enter.
2. Click Show Options at the bottom-left corner of the Remote Desktop window.
3. Go to the Display tab and drag the Display configuration slider all the way to the right (Full Screen).
4. Go back to the General tab, type 127.0.0.1:3390 in the Computer box, and click Connect.
5. When the security certificate popup appears, check Don't ask me again for connections to this computer and click Yes.
6. On the xrdp login screen, leave Session set to Xorg, enter your Ubuntu username and password, and click OK.

How to Properly Exit and Free RAM When Done

1. Inside the Ubuntu desktop, click Applications (top-left) > Log Out > Log Out.
2. In your Ubuntu WSL terminal, stop the background server:bash
sudo systemctl stop xrdp
Use code with caution.
3. (Optional) To completely free all WSL memory back to Windows, open Windows PowerShell or Command Prompt and run:powershell
wsl --shutdown
Use code with caution.
Would you like a clean, copy-pasteable one-click Windows batch script so you can launch your Ubuntu desktop anytime without manually opening the terminal and mstsc?
AI responses may include mistakes. Learn more
