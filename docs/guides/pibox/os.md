# PiBox OS

The OS we maintain and distribute is a Ubuntu Server 21.04 image with some minimal modifications:

-   Kubernetes & the [KubeSail Agent](/#attaching-a-cluster), which provides a consistent API for easily installing software via [templates](/templates)
-   SATA Kernel modules (These are disabled by default in the base Ubuntu Raspberry Pi image)
-   Display kernel modules, for the 1.3" front panel display
-   Common unix tools: curl, vim, git
