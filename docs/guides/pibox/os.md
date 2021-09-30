# PiBox OS

The OS image we maintain is a Ubuntu Server 21.04 image with some minimal modifications. Download here: [TODO]

The rest of this page contains the instructions for making those modifications yourself if you decide to reflash your pibox. In general, the modifications we make are:

-   Kubernetes, which provides a consistent API for installing software via [templates](/templates), as well as the [KubeSail Agent](/#attaching-a-cluster)
-   SATA Kernel modules (These are disabled by default in the base Ubuntu Raspberry Pi image)
-   Display kernel modules, for the 1.3" front panel display
-   Commonly used unix tools: curl, vim, git

## Logging in via SSH

If you ordered a PiBox from us and gave us your github username, we've automatically installed your public github keys into the `ubuntu` user. So after plugging your PiBox into your local network, you can find its local IP address on the front-panel display and simply `ssh ubuntu@<LOCAL_IP_ADDRESS>`

## Enabling the SATA Kernel Module

Enabling the SATA ports requires compiling the SATA modules into the kernel. This step takes the longest, so you may want to start this and open another tab for the sections below while the kernel compiles.

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
# sudo cp arch/arm64/boot/dts/*.dtb /boot/
sudo cp arch/arm64/boot/dts/overlays/*.dtb* /boot/firmware/overlays/
sudo cp arch/arm64/boot/dts/overlays/README /boot/firmware/overlays/
sudo cp arch/arm64/boot/Image /boot/$KERNEL.img
```

Further detailed instructions and discussion can be found on Jeff Geerling's [PCI device guide on GitHub](https://github.com/geerlingguy/raspberry-pi-pcie-devices/issues/1#issuecomment-717578358)

## Install MicroK8s

MicroK8s is our prefered Kubernetes distribution. Its maintained by Canonical, is updated regularly, and performs well on low-power devices, such as Raspberry Pis.

    sudo snap install microk8s --classic
    # Enable basics and stats
    sudo microk8s.enable dns storage prometheus

By default, container data will be saved to `/var/snap/microk8s`, which is on the Pi's eMMC or SD card. This built in storage is slower and less resiliant than the SSDs. Mounting this directory on one of the SSDs allows you to run containers faster and with more ephemeral storage.

    # TODO

## Install KubeSail

KubeSail helps you manage software on your PiBox, or any other computer running Kubernetes. If you don't yet have a KubeSail account,

    kubectl create -f https://byoc.kubesail.com/<YOUR_KUBESAIL_USERNAME>.yaml?initialID=PiBox

This will start the KubeSail agent within Kubernetes. After a few minutes, your cluster will appear in the [clusters](https://kubesail.com/clusters) tab of the KubeSail dashboard.

> NOTE: When we ship the PiBox, we install a script that installs the KubeSail agent during boot if `/boot/kubesail-username.txt` is present. The instructions for installing that boot script are below, but are not necessary.

    sudo mkdir /opt/kubesail/

Save the following to `/opt/kubesail/init.sh`

```bash
#!/bin/bash
if [[ ! -f /boot/kubesail-username.txt ]]; then
    echo "Not installing KubeSail agent: /boot/firmware/kubesail-username.txt file not found"
    exit 0
fi

KUBESAIL_USERNAME=$(cat /boot/firmware/kubesail-username.txt)
echo "Installing KubeSail agent with username: $KUBESAIL_USERNAME"

microk8s.kubectl get namespace kubesail-agent || {
    #microk8s.refresh-certs
    microk8s.kubectl create -f https://byoc.kubesail.com/$KUBESAIL_USERNAME.yaml?initialID=PiBox
}
```

Then make executable

    sudo chmod +x /opt/kubesail/init.sh

Save the following to `/etc/systemd/system/kubesail-init.service`

```bash
[Unit]
After=network.service
After=snap.microk8s.daemon-apiserver
[Service]
ExecStart=/opt/kubesail/init.sh
[Install]
WantedBy=default.target
```

Then to enable the script:

    sudo systemctl daemon-reload; sudo systemctl enable kubesail-init.service;

## Install commonly used tools

This section is optional. These utilities make debugging and installing additional software easier

```
sudo apt install curl vim git
```

## Enable USB (Raspberry Pi OS only)

If you are using Raspberry Pi OS, you will need to enable the USB 2.0 ports on the Compute Module 4. Edit the boot config file at `/boot/config.txt` and add:

    dtoverlay=dwc2,dr_mode=host

## Enabling PWM Fan Support

To make the fan quiet and only spin as fast as necessary, we install a service that sends the correct signal to the fan using the Pi's hardware PWM controller. This code can be found in [our fork]() of `alwynallan`'s original gist on GitHub.

```bash
git clone https://github.com/kubesail/rpi-pwm-fan.git
cd rpi-pwm-fan
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

Adafruit has [a guide](https://learn.adafruit.com/adafruit-mini-pitft-135x240-color-tft-add-on-for-raspberry-pi/1-3-240x240-kernel-module-install) which is compatible with the display used in PiBox. We modified Adafruit's code in combination with prometheus-png to render stats to the display. This code runs as containers within Kubernetes and the source code lives in two repositories:

-   Our fork of prometheus-png built for `arm64` arch: https://github.com/kubesail/prometheus-png
-   Our python script to render the resulting PNGs to the display: https://github.com/kubesail/pibox-pnger

> NOTE: In our testing, if you are trying the Python "easy way", and installing the `adafruit-circuitpython-rgb-display` library, you will need to install `RPi.GPIO` manually via pip3. Once installed, you can try installing the Adafruit library again.
>
> ```bash
> export CFLAGS=-fcommon
> pip3 install RPi.GPIO
> ```