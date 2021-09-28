# PiBox OS

The OS image we maintain is a Ubuntu Server 21.04 image with some minimal modifications. Download here: [TODO]

The rest of this page contains the instructions for making those modifications yourself if you decide to reflash your pibox. In general, the modifications we make are:

-   Kubernetes, which provides a consistent API for installing software via [templates](/templates), as well as the [KubeSail Agent](/#attaching-a-cluster)
-   SATA Kernel modules (These are disabled by default in the base Ubuntu Raspberry Pi image)
-   Display kernel modules, for the 1.3" front panel display
-   Commonly used unix tools: curl, vim, git

## Install MicroK8s

MicroK8s is our prefered Kubernetes distribution. Its maintained by Canonical, is updated regularly, and performs well on low-power devices, such as Raspberry Pis.

    sudo snap install microk8s --classic
    # Enable basics and stats
    sudo microk8s.enable dns storage prometheus

By default, container data will be saved to `/var/snap/microk8s`, which is on the Pi's eMMC or SD card. This built in storage is slower and less resiliant than the SSDs. Mounting this directory on one of the SSDs allows you to build up containers.

    # TODO

## Install KubeSail

MicroK8s is our prefered Kubernetes distribution. Its maintained by Canonical, is updated regularly, and performs well on low-power devices, such as Raspberry Pis.

    sudo microk8s.kubectl enable

## Install commonly used tools

This section is optional. These utilities make debugging and installing additional software easier

```
sudo apt install curl vim git
```

## Enable USB (Raspberry Pi OS only)

If you are using Raspberry Pi OS, you will need to enable the USB 2.0 ports on the Compute Module 4. Edit the boot config file at `/boot/config.txt` and add:

    dtoverlay=dwc2,dr_mode=host

## Enabling the SATA Kernel Module

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
make -j4 zImage modules dtbs # 'Image' on 64-bit
sudo make modules_install
sudo cp arch/arm/boot/dts/*.dtb /boot/
sudo cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
sudo cp arch/arm/boot/dts/overlays/README /boot/overlays/
sudo cp arch/arm/boot/zImage /boot/$KERNEL.img
```

    Further detailed instructions and discussion can be found on Jeff Geerling's [PCI device guide on GitHub](https://github.com/geerlingguy/raspberry-pi-pcie-devices/issues/1#issuecomment-717578358)

## Enabling the 1.3" LCD display

To enable the front-panel display, the [SPI interface needs to be turned on](https://blog.stabel.family/raspberry-pi-4-multiple-spis-and-the-device-tree/). Edit the boot config file at `/boot/config.txt` and add:

    dtoverlay=spi0-1cs

You can then use a Python library or install the kernel module in order to draw images to the display. Adafruit has a guide which is compatible with the display used in PiBox. https://learn.adafruit.com/adafruit-mini-pitft-135x240-color-tft-add-on-for-raspberry-pi/1-3-240x240-kernel-module-install

> NOTE: In our testing, if you are trying the Python "easy way", and installing the `adafruit-circuitpython-rgb-display` library, you will need to install `RPi.GPIO` manually via pip3. Once installed, you can try installing the Adafruit library again.
>
> ```bash
> export CFLAGS=-fcommon
> pip3 install RPi.GPIO
> ```

After these changes, you will need to `sudo reboot`.
