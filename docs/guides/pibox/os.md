# Using a custom Linux OS on your PiBox

We [maintain and distribute a modified 64-bit Raspberry Pi OS image](https://github.com/kubesail/pibox-os/releases) which is pre-configured to be perfect for the PiBox. The rest of this page contains the instructions for making those modifications yourself if you decide to [reflash your PiBox](/guides/pibox/rpiboot). In general, the modifications we make are:

-   Fan support (PWM) for quiet fan operation
-   SATA Kernel modules
-   Install Kubernetes (via [K3s](https://k3s.io/))
-   Tweaks for stability and performance
-   Display kernel modules for the 1.3" front panel display

If you're using our OS Image, this guide has already been completed for you! You can also start with the base 64-bit Raspberry Pi image from https://downloads.raspberrypi.org/raspios_arm64

## Dedicating an SSD to Kubernetes

<!-- prettier-ignore -->
!!! important
    We recommend using one or more SSDs for your Kubernetes installation and storage. You'll want to format a disk and mount it at `/var/snap` before installing Kubernetes. This storage can then be used by Kubernetes for it's storage system. This piece is optional, but we strongly recommend it!

<!-- prettier-ignore -->
!!! danger
    If you've already installed K3s, please first uninstall with `/usr/local/bin/k3s-uninstall.sh`

Take a look to see if your disks have been detected: `lsblk | fgrep disk` - if not, try updating the OS with `apt update && apt upgrade` and restart. If you still don't see your disks, see the "Enabling the SATA Kernel Module" section below.

```bash
# Format the entire /dev/sda disk (WARNING! This will wipe data!)
sudo parted -a opt /dev/sda mkpart primary ext4 0% 100%

# Format the partition
sudo mkfs.ext4 -L kubernetesdata /dev/sda1

# Mount the partition in place! K3s usually lives at "/var/lib/rancher", whereas microk8s uses "/var/snap"
sudo mkdir -p /var/lib/rancher
sudo bash -c "echo '/dev/sda1 /var/lib/rancher ext4 defaults,nofail,noatime,discard,errors=remount-ro 0 0' >> /etc/fstab"
```

## Install K3s

[K3s](https://k3s.io/) is our preferred Kubernetes distribution. It's maintained by Rancher, is updated regularly, and performs well on low-power devices, such as Raspberry Pis. Other distributions of Kubernetes should work fine on the PiBox and with KubeSail.com, but this guide focuses on K3s. We recommend K3s over Microk8s because of its dramatically reduced resource requirements as of the time of writing (11/1/2021)

```bash
# On Raspberry PI OS, the path is /boot/cmdline.txt, on Ubuntu it's /boot/firmware/cmdline.txt
# TLDR: Add 'cgroup_enable=memory cgroup_memory=1' to that file and reboot
sudo bash -c "grep -qxF 'cgroup_enable=memory cgroup_memory=1' /boot/cmdline.txt || sed -i 's/$/ cgroup_enable=memory cgroup_memory=1/' /boot/cmdline.txt"
sudo reboot

# Install K3s - see https://k3s.io/ for more
curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=latest sh -
```

## Install KubeSail

KubeSail helps you manage software on your PiBox, or any other computer running Kubernetes. If you don't yet have a KubeSail account, creating one is as easy as [signing up with GitHub](https://kubesail.com/). Once you've done that, install the setup script:

```bash
curl -s https://raw.githubusercontent.com/kubesail/pibox-os/main/setup.sh | sudo bash
```

Then run

```bash
sudo kubesail
```

to set up KubeSail and install your SSH keys.

After a few minutes, your PiBox will appear in the [clusters](https://kubesail.com/clusters) tab of the KubeSail dashboard.

## Enabling PWM Fan Support

To make the fan quiet and only spin as fast as necessary, we install a service that sends the correct signal to the fan using the Pi's hardware PWM controller. This code can be found in [our fork](https://github.com/kubesail/pibox-os/tree/main/pwm-fan) of `alwynallan`'s original gist on GitHub.

```bash
git clone https://github.com/kubesail/pibox-os.git
cd pibox-os/pwm-fan
tar zxvf bcm2835-1.68.tar.gz
cd bcm2835-1.68
./configure && make && sudo make install
cd ..
make && sudo make install
```

## Enable USB (Raspberry Pi OS only)

If you are using Raspberry Pi OS, you will need to enable the USB 2.0 ports on the Compute Module 4. Edit the boot config file at `/boot/config.txt` and add:

    dtoverlay=dwc2,dr_mode=host

## Enabling the SATA Kernel Module

<!-- prettier-ignore -->
!!! important
    Raspberry Pi OS will soon ship the SATA modules by default. Use `apt update && apt upgrade` to upgrade!

You may want to see if your disks are already detected (`lsblk | fgrep disk`) before building these modules, which can take some time. Instructions for Compiling the Ubuntu-raspi kernel can be found at https://askubuntu.com/a/1242267 and cross-compilation instructions can be found at https://github.com/carlonluca/docker-rpi-ubuntu-kernel

Enabling the SATA ports requires compiling the SATA modules into the kernel.

```bash
# Install dependencies
sudo apt install -y git bc bison flex libssl-dev make libncurses5-dev

# Clone source
git clone --depth=1 https://github.com/raspberrypi/linux

# Apply default configuration
cd linux
export KERNEL=kernel8 # use kernel8 for 64-bit, or kernel7l for 32-bit
make bcm2711_defconfig

# Customize the .config further with menuconfig
make menuconfig
# Enable the following:
# Device Drivers:
#   -> Serial ATA and Parallel ATA drivers (libata)
#     -> AHCI SATA support

nano .config
# (edit CONFIG_LOCALVERSION and add a suffix that helps you identify your build)

# Build the kernel and copy everything into place
make -j4 Image modules dtbs # 'zImage' on 32-bit
sudo make modules_install
sudo cp arch/arm64/boot/dts/*.dtb /boot/
sudo cp arch/arm64/boot/dts/overlays/*.dtb* /boot/overlays/
sudo cp arch/arm64/boot/dts/overlays/README /boot/overlays/
sudo cp arch/arm64/boot/Image /boot/$KERNEL.img

# Reboot the system
reboot
```

Further detailed instructions and discussion can be found on Jeff Geerling's [PCI device guide on GitHub](https://github.com/geerlingguy/raspberry-pi-pcie-devices/issues/1#issuecomment-717578358)

## Optimize system for EMMC, RaspberryPI

We'll make a few tweaks intended to optimize disk-usage on the EMMC disk, which is the slowest component in the PiBox. These are optional steps.

```bash
# Store system logs in memory, instead of writing to disk, and lower log verbosity
sudo sed -i "s/#Storage.*/Storage=volatile/" /etc/systemd/journald.conf
sudo sed -i 's/.MaxLevelStore.*/MaxLevelStore=info/' /etc/systemd/journald.conf
sudo sed -i 's/.MaxLevelSyslog.*/MaxLevelSyslog=info/' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald.service

# Disable swapfile - note that while you can use a swapspace on an SSD, Swap and Kubernetes do not play nicely for free.
# So the simplest option is to just disable swap entirely
swapoff -a
dphys-swapfile swapoff

# Mount /var/tmp as tmpfs filesystems to extend EMMC lifetime
echo "tmpfs /var/tmp tmpfs defaults,noatime,nosuid,nodev,noexec,mode=0755,size=1M 0 0" | sudo tee -a /etc/fstab

```

## Enable support for '.local' DNS Names

KubeSail agent will automatically publish DNS addresses for domains that end in `.local` to your network. This requires that that operating system that KubeSail Agent runs on has `avahi-daemon` installed and running. Note that this is typically installed on most major operating systems, but you can make sure with:

```bash
apt install avahi-daemon
```

## Enabling the 1.3" LCD display

<!-- prettier-ignore -->
!!! important
    **Raspberry Pi OS** only. Ubuntu ships with the SPI interface enabled by default

To enable the front-panel display, the [SPI interface needs to be turned on](https://blog.stabel.family/raspberry-pi-4-multiple-spis-and-the-device-tree/). Edit the boot config file at `/boot/config.txt` and add:

    dtoverlay=spi0-1cs

After these changes, you will need to `sudo reboot`.

You can then use a Python library or install the kernel module in order to draw images to the display. See below for details.

## Modifying the image / stats shown on the display

Adafruit has [a guide](https://learn.adafruit.com/adafruit-mini-pitft-135x240-color-tft-add-on-for-raspberry-pi/1-3-240x240-kernel-module-install) which is compatible with the display used in PiBox. We modified Adafruit's code in combination with prometheus-png to render stats to the display. This code runs as containers within Kubernetes, installed via this [template](https://kubesail.com/template/erulabs/pibox-display-renderer), and the source code lives in two repositories:

-   Our fork of prometheus-png built for `arm64` arch: https://github.com/kubesail/prometheus-png
-   Our python script to render the resulting PNGs to the display: https://github.com/kubesail/pibox-os/tree/main/lcd-display

<!-- prettier-ignore -->
!!! note
    In our testing, if you are trying the Python "easy way", and installing the `adafruit-circuitpython-rgb-display` library, you will need to install `RPi.GPIO` manually via pip3. Once installed, you can try installing the Adafruit library again.

    ```bash
    CFLAGS=-fcommon pip3 install RPi.GPIO
    ```

## The complete script

For completeness, here is more or less the entire script used to pre-provision our PiBox OS:

```bash
apt-get update -yqq
apt-get full-upgrade -yqq
apt-get autoremove -yqq
apt-get autoclean -yqq
apt-get install -yqq vim lvm2

# Reduce logging and store in memory to reduce EMMC wear
sed -i 's/.MaxLevelStore.*/MaxLevelStore=info/' /etc/systemd/journald.conf
sed -i 's/.MaxLevelSyslog.*/MaxLevelSyslog=info/' /etc/systemd/journald.conf
sed -i "s/#Storage.*/Storage=volatile/" /etc/systemd/journald.conf
systemctl restart systemd-journald.service

# Add tmpfs at /tmp to reduce EMMC wear
echo "tmpfs /var/tmp tmpfs defaults,noatime,nosuid,nodev,noexec,mode=0755,size=1M 0 0" >> /etc/fstab

# Enable Fan Support
git clone https://github.com/kubesail/pibox-os.git && \
  cd pibox-os/pwm-fan && \
  tar zxvf bcm2835-1.68.tar.gz && cd bcm2835-1.68 && \
  ./configure && make && make install && cd ../ && \
  make && make install && cd ../.. && rm -rf pibox-os

# SSH Config
echo "TCPKeepAlive yes" >> /etc/ssh/sshd_config
service sshd restart

# Kernel settings
grep -qxF 'cgroup_enable=memory cgroup_memory=1' /boot/cmdline.txt || sed -i 's/$/ cgroup_enable=memory cgroup_memory=1/' /boot/cmdline.txt
echo "dtoverlay=spi0-1cs" >> /boot/config.txt
echo "dtoverlay=dwc2,dr_mode=host" >> /boot/config.txt

# Swap
swapoff -a
dphys-swapfile swapoff
sysctl -w vm.swappiness=1
sed -i 's/vm.swappiness=.*/vm.swappiness=1/' /etc/sysctl.conf

# Install K3s
if [[ ! -d /var/lib/rancher/k3s/data ]]; then
  curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=latest sh
fi

# Install helm
curl -sLo helm.tar.gz https://get.helm.sh/helm-v3.7.2-linux-arm64.tar.gz
tar zxf helm.tar.gz
mv linux-arm64/helm /usr/local/bin/
chmod +x /usr/local/bin/helm
rm -rf linux-arm64

# Pibox Disk Provisioner - Note, this script will potentially format attached disks. Careful!
curl -sLo pibox-disk-provisioner.sh https://docs.kubesail.com/static/pibox-disk-provisioner.sh
chmod +x pibox-disk-provisioner.sh
./pibox-disk-provisioner.sh
# Run disk provisioner before K3s starts
sed -i '/^\[Service\]/a ExecStartPre=/root/pibox-disk-provisioner.sh' /etc/systemd/system/k3s.service
systemctl daemon-reload
```
