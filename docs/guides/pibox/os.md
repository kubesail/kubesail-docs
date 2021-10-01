# PiBox OS

> Download the latest version [on GitHub](https://github.com/kubesail/pibox-os/releases)

We maintain and distribute a modified 64-bit Raspberry Pi OS image which adds some additional kernel modules.

The rest of this page contains the instructions for making those modifications yourself if you decide to [reflash your PiBox](/guides/pibox/rpiboot). In general, the modifications we make are:

-   Kubernetes, which provides a consistent API for installing software via [templates](/templates), as well as the [KubeSail Agent](/#attaching-a-cluster)
-   SATA Kernel modules (These are enabled by default in Raspberry Pi OS 64-bit. They need to be compiled for Raspberry Pi OS 32-bit and Ubuntu images)
-   Display kernel modules, for the 1.3" front panel display
-   PWM fan support using the Pi's hardware PWM controller

## Logging in via SSH

If you ordered a PiBox from us and gave us your github username, we've automatically installed your public github keys into the `pi` user. So after plugging your PiBox into your local network, you can find its local IP address on the front-panel display and simply `ssh ubuntu@<LOCAL_IP_ADDRESS>`

## Enabling the SATA Kernel Module

> NOTE: These instructions apply to Raspberry Pi OS 32-bit only. 64-bit Pi OS now ships the SATA modules by default. Instructions for Compiling the Ubuntu-raspi kernel can be found at https://askubuntu.com/a/1242267 and cross-compilation instructions can be found at https://github.com/carlonluca/docker-rpi-ubuntu-kernel

Enabling the SATA ports requires compiling the SATA modules into the kernel.

```bash
# Install dependencies
sudo apt install -y git bc bison flex libssl-dev make libncurses5-dev

# Clone source
git clone --depth=1 https://github.com/raspberrypi/linux

# Apply default configuration
cd linux
export KERNEL=kernel7l # use kernel8 for 64-bit, or kernel7l for 32-bit
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
make -j4 zImage modules dtbs # 'Image' on 64-bit
sudo make modules_install
sudo cp arch/arm64/boot/dts/*.dtb /boot/
sudo cp arch/arm64/boot/dts/overlays/*.dtb* /boot/overlays/
sudo cp arch/arm64/boot/dts/overlays/README /boot/overlays/
sudo cp arch/arm64/boot/Image /boot/$KERNEL.img
```

Further detailed instructions and discussion can be found on Jeff Geerling's [PCI device guide on GitHub](https://github.com/geerlingguy/raspberry-pi-pcie-devices/issues/1#issuecomment-717578358)

## Install MicroK8s

MicroK8s is our prefered Kubernetes distribution. Its maintained by Canonical, is updated regularly, and performs well on low-power devices, such as Raspberry Pis.

```bash
# Install Snap
sudo apt update
sudo apt install snapd

# Install Microk8s
sudo snap install microk8s --classic
# Enable basics and stats
sudo microk8s enable dns storage prometheus

# Allow the current user to run microk8s commands
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
```

MicroK8s [has a bug](https://github.com/ubuntu/microk8s/pull/2617) where it will pick up on network changes and restart kubelite when it shouldn't. To fix this,

```bash
vim /var/snap/microk8s/current/args/kube-apiserver
```

and add the line

    --bind-address=0.0.0.0

### Increasing Kubernetes performance

By default, container data will be saved to `/var/snap/microk8s`, which is on the Pi's eMMC or SD card. This built in storage is slower and less resiliant than the external SATA SSDs. Mounting this directory on one of the SSDs allows you to run containers faster and with more ephemeral storage.

```bash
vim /etc/fstab
```

and add the line

    /dev/sda1 /var/snap ext4 defaults,nofail 0 0

## Install KubeSail

KubeSail helps you manage software on your PiBox, or any other computer running Kubernetes. If you don't yet have a KubeSail account, creating one is as easy as [signing up with GitHub](https://kubesail.com/). Once you've done that, simply replace your username in the following command and run it:

```bash
echo "YOUR_KUBESAIL_USERNAME" | sudo tee -a /boot/kubesail-username.txt
```

Then install the KubeSail agent:

```bash
curl -s https://raw.githubusercontent.com/kubesail/pibox-os/main/agent-installer.sh | sudo bash
```

After a few minutes, your cluster will appear in the [clusters](https://kubesail.com/clusters) tab of the KubeSail dashboard.

## Enable USB (Raspberry Pi OS only)

If you are using Raspberry Pi OS, you will need to enable the USB 2.0 ports on the Compute Module 4. Edit the boot config file at `/boot/config.txt` and add:

    dtoverlay=dwc2,dr_mode=host

## Enabling PWM Fan Support

To make the fan quiet and only spin as fast as necessary, we install a service that sends the correct signal to the fan using the Pi's hardware PWM controller. This code can be found in [our fork]() of `alwynallan`'s original gist on GitHub.

```bash
git clone https://github.com/kubesail/pibox-os.git
cd pibox-os/rpi-pwm-fan
tar zxvf bcm2835-1.68.tar.gz
cd bcm2835-1.68
./configure
make
sudo make install
cd ..
make
sudo make install
```

## Enabling the 1.3" LCD display

> NOTE: Raspberry Pi OS only. Ubuntu ships with the SPI interface enabled by default

To enable the front-panel display, the [SPI interface needs to be turned on](https://blog.stabel.family/raspberry-pi-4-multiple-spis-and-the-device-tree/). Edit the boot config file at `/boot/config.txt` and add:

    dtoverlay=spi0-1cs

After these changes, you will need to `sudo reboot`.

You can then use a Python library or install the kernel module in order to draw images to the display. See below for details.

## Modifying the image / stats shown on the display

Adafruit has [a guide](https://learn.adafruit.com/adafruit-mini-pitft-135x240-color-tft-add-on-for-raspberry-pi/1-3-240x240-kernel-module-install) which is compatible with the display used in PiBox. We modified Adafruit's code in combination with prometheus-png to render stats to the display. This code runs as containers within Kubernetes, installed via this [template](https://kubesail.com/template/erulabs/pibox-display-renderer), and the source code lives in two repositories:

-   Our fork of prometheus-png built for `arm64` arch: https://github.com/kubesail/prometheus-png
-   Our python script to render the resulting PNGs to the display: https://github.com/kubesail/pibox-os/tree/main/lcd-display

> NOTE: In our testing, if you are trying the Python "easy way", and installing the `adafruit-circuitpython-rgb-display` library, you will need to install `RPi.GPIO` manually via pip3. Once installed, you can try installing the Adafruit library again.
>
> ```bash
> export CFLAGS=-fcommon
> pip3 install RPi.GPIO
> ```
