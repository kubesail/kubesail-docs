# Install Kubernetes

If you're working with a managed cloud provider like KubeSail, EKS, GKE, or Digital Ocean, Kubernetes comes pre-installed. If you're working with a local machine, here are some guides to install Kubernetes.

- [Docker Desktop](#docker-desktop) (easiest)
- [Microk8s](#microk8s)
- [K3s](#k3s)
- [Kubernetes the Hard Way](#kubernetes-the-hard-way)

## Docker Desktop

For Mac and Windows
Install Docker
Run Kubernetes

## Microk8s

[Microk8s](https://microk8s.io/) is a lightweight version of Kubernetes designed for IOT and edge computing on a Linux operating system. For example, you can set up Microk8s on a Raspberry Pi to run a single-node cluster.

1. Prepare an SD card
1. Set up the WiFi
1. Log into the Raspberry Pi

Here is how to [set up Microk8s on a Raspberry Pi 4](https://kubesail.com/blog/microk8s-raspberry-pi).


1. **Prepare an SD card**

    If you don't already have an operating system on your SD card, download [the Raspberry Pi Imager](https://www.raspberrypi.org/downloads/) to your computer, select **Ubuntu 64-bit**, and hit "write". Get the latest version of Ubuntu. This process takes about 5 minutes. 

    **NOTE**: If you are connecting your Pi via Ethernet, insert the SD card into the Pi, power it on, and skip the WiFi section. Otherwise don't remove your SD card from your computer yet.

1. **Set up the WiFi**

    Configure these network details on the SD card before you power on the Pi. Open the file called `network-config` on the root of the drive. Uncomment a section called `wifis` by removing the `#`'s. Then update with your network's SSID and password.

    Your file should look like this, for example, if your network is named `My WiFi Network`:

        version: 2
        ethernets:
        eth0:
            dhcp4: true
            optional: true
        wifis:
        wlan0:
            dhcp4: true
            optional: true
            access-points:
            My WiFi Network:
                password: "my-wifi-password"

    Take your SD card out, insert into the Pi, and power it on.

1. **Log into the Raspberry Pi**

    The Pi should register its hostname with your router, so secure shell into the server.

        ssh ubuntu@ubuntu

    If that fails with an error like `Could not resolve hostname ubuntu`, then log into your router and find the IP of your Pi. In that case, log in via `ssh ubuntu@<YOUR_PI_IP_ADDRESS>`.

    The initial password is `ubuntu`, which you'll need to change on first login. Once you're in, install Microk8s.

        sudo snap install microk8s --classic

    The Raspberry Pi needs a small boot configuration change to enable cgroup memory, otherwise [Kubernetes will never become Ready](https://github.com/ubuntu/microk8s/issues/728#issuecomment-548722833). We will also enable DNS and Storage, which many images depend on.

        sudo sed -i '${s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1/}' /boot/firmware/cmdline.txt
        sudo microk8s.enable dns storage
        sudo reboot now

    Wait for the Pi to reboot, and then secure shell back into the machine. See which machines are in our cluster:

        sudo microk8s.kubectl get nodes

    This may take a minute while the Pi starts up all the software that powers Kubernetes. Eventually you should see:

        NAME     STATUS   ROLES    AGE   VERSION
        ubuntu   Ready    <none>   95m   v1.17.0

    The Raspberry Pi is now running as a single-node cluster.

## K3s

## Kubernetes the Hard Way

https://github.com/kelseyhightower/kubernetes-the-hard-way

