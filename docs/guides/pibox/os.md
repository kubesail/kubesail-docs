# Using a custom Linux OS on your PiBox

We [maintain and distribute a modified 64-bit Raspberry Pi OS image](https://github.com/kubesail/pibox-os/releases) which is pre-configured to be perfect for the PiBox. The rest of this page contains the instructions for making those modifications yourself if you decide to [reflash your PiBox](/guides/pibox/rpiboot). In general, the modifications we make are:

-   Fan support (PWM) for quiet fan operation
-   SATA Kernel modules
-   Install Kubernetes (via [k3s](https://k3s.io/))
-   Tweaks for stability and performance
-   Display kernel modules for the 1.3" front panel display

If you're using our OS Image, this guide has already been completed for you!

## Dedicating an SSD to Kubernetes

<!-- prettier-ignore -->
!!! important
    We recommend using one or more SSDs for your Kubernetes installation and storage. You'll want to format a disk and mount it at `/var/snap` before installing Kubernetes. This storage can then be used by Kubernetes for it's storage system. This piece is optional, but we strongly recommend it!

<!-- prettier-ignore -->
!!! danger
    If you've already installed k3s, please first uninstall with `/usr/local/bin/k3s-uninstall.sh`

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

## Install K3S

[K3S](https://k3s.io/) is our preferred Kubernetes distribution. It's maintained by Rancher, is updated regularly, and performs well on low-power devices, such as Raspberry Pis. Other distributions of Kubernetes should work fine on the PiBox and with KubeSail.com, but this guide focuses on k3s. We recommend k3s over Microk8s because of its dramatically reduced resource requirements as of the time of writing (11/1/2021)

```bash
# On Raspberry PI OS, the path is /boot/cmdline.txt, on Ubuntu it's /boot/firmware/cmdline.txt
# TLDR: Add 'cgroup_enable=memory cgroup_memory=1' to that file and reboot
sudo bash -c "grep -qxF 'cgroup_enable=memory cgroup_memory=1' /boot/cmdline.txt || sed -i 's/$/ cgroup_enable=memory cgroup_memory=1/' /boot/cmdline.txt"
sudo reboot

# Install k3s - see https://k3s.io/ for more
curl -sfL https://get.k3s.io | sh -
```

## Install KubeSail

KubeSail helps you manage software on your PiBox, or any other computer running Kubernetes. If you don't yet have a KubeSail account, creating one is as easy as [signing up with GitHub](https://kubesail.com/). Once you've done that, simply replace your username in the following command and run it:

```bash
sudo bash -c "echo YOUR_KUBESAIL_USERNAME > /boot/kubesail-username.txt"
```

Then install the KubeSail agent:

```bash
curl -s https://raw.githubusercontent.com/kubesail/pibox-os/main/agent-installer.sh | sudo bash
```

After a few minutes, your cluster will appear in the [clusters](https://kubesail.com/clusters) tab of the KubeSail dashboard.

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

Further detailed instructions and discussion can be found on Jeff Geerling's [PCI device guide on GitHub](https://github.com/geerlingguy/raspberry-pi-pcie-devices/issues/1#issuecomment-717578358)

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
