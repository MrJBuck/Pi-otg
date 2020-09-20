# Pi-otg

This will enable a one wire, plug and play solution between the Raspberry Pi 4 and a Macbook. The Raspberry Pi automatically hands out a dhcp address so you do not have to fiddle with assigning one yourself. When the USB otg interface comes up there is a listener that launches a VNC session automatically. Simply plug your Pi into your Macbook and it plops you into its desktop.


Video: http://i.imgur.com/AQnWGGg.mp4

# Installation Instructions (Run everything as root)
**Macbook side:**
* Copy vnc.sh to /Library/Scripts/
* Run chmod 755 /Library/Scripts/vnc.sh
* Copy vnc.plist to /Library/LaunchAgents/
* Run chmod 600 /Library/LaunchAgents/vnc.plist
*  Run sudo launchctl load /Library/LaunchAgents/vnc.plist to start the watchdog

**Raspberry Pi side**
* Run pi-setup.sh
