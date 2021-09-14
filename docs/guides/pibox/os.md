# PiBox OS

The OS we maintain and distribute is a Ubuntu Server 21.04 image with some minimal modifications:

-   Kubernetes & the [KubeSail Agent](/#attaching-a-cluster), which provides a consistent API for installing software via [templates](/templates)
-   SATA Kernel modules (These are disabled by default in the base Ubuntu Raspberry Pi image)
-   Display kernel modules, for the 1.3" front panel display
-   Common unix tools: curl, vim, git

# Install microk8s

MicroK8s is our prefered Kubernetes distribution. Its maintained by Canonical, is updated regularly, and performs well on low-power devices, such as Raspberry Pis.

    sudo snap install microk8s --classic
    # Enable basics and stats
    sudo microk8s.enable dns storage prometheus
