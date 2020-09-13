#!/bin/bash
echo "loading module"
sed -i 's/$/ modules-load=dwc2/' /boot/cmdline.txt
echo "dtoverlay=dwc2" >> /boot/config.txt
echo "libcomposite" >> /etc/modules
echo "denyinterfaces usb0" >> /etc/dhcpcd.conf

echo "installing dnsmasq"
apt-get -y install dnsmasq

echo "configuring dnsmasq"
touch /etc/dnsmasq.d/usb
echo "interface=usb0" >> /etc/dnsmasq.d/usb
echo "dhcp-range=192.168.150.2,192.168.150.6,255.255.255.248,1h" >> /etc/dnsmasq.d/usb
echo "dhcp-option=3" >> /etc/dnsmasq.d/usb
echo "leasefile-ro" >> /etc/dnsmasq.d/usb

echo "creating interface"
touch /etc/network/interfaces.d/usb0
echo "auto usb0" >> /etc/network/interfaces.d/usb0
echo "allow-hotplug usb0" >> /etc/network/interfaces.d/usb0
echo "iface usb0 inet static" >> /etc/network/interfaces.d/usb0
echo "  address 192.168.150.1" >> /etc/network/interfaces.d/usb0
echo "  netmask 255.255.255.248" >> /etc/network/interfaces.d/usb0
modprobe g_ether
service dnsmasq restart

echo "modifying rc.local. A backup is saved if anything messes up"
cp /etc/rc.local /etc/rc.local.bak
sed -i '$ d' /etc/rc.local
echo "modprobe g_ether" >>/etc/rc.local
echo "exit 0" >> /etc/rc.local
ifup usb0

echo "installing tightvnc"
apt-get -y install tightvncserver

echo "configuring tightvnc service"
touch /etc/systemd/system/tightvncserver.service
echo "[Unit]" >> /etc/systemd/system/tightvncserver.service
echo "Description=TightVNC remote desktop server" >> /etc/systemd/system/tightvncserver.service
echo "After=sshd.service" >> /etc/systemd/system/tightvncserver.service
echo "" >> /etc/systemd/system/tightvncserver.service
echo "[Service]" >> /etc/systemd/system/tightvncserver.service
echo "Type=dbus" >> /etc/systemd/system/tightvncserver.service
echo "ExecStart=/usr/bin/tightvncserver :1" >> /etc/systemd/system/tightvncserver.service
echo "User=pi" >> /etc/systemd/system/tightvncserver.service
echo "Type=forking" >> /etc/systemd/system/tightvncserver.service
echo "" >> /etc/systemd/system/tightvncserver.service
echo "[Install]" >> /etc/systemd/system/tightvncserver.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/tightvncserver.service
chown root:root /etc/systemd/system/tightvncserver.service
chmod 755 /etc/systemd/system/tightvncserver.service
tightvncserver
systemctl start tightvncserver.service
systemctl enable tightvncserver.service
