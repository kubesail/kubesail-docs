# PiBox by KubeSail

Designed for simplicity, KubeSail now ships a custom low-cost cluster, pre-installed with Kubernetes and the KubeSail agent. The design is based on the [Raspberry Pi 4 Compute Module](https://datasheets.raspberrypi.org/cm4/cm4-product-brief.pdf), includes 2 expandable SATA SSD ports, and costs $299. PiBox is ideal for home and small office use, and makes it easy to take advantage of KubeSail templates and backups.

Order now at [pibox.io](https://pibox.io)!

-   [**About**](/pibox/#about-the-hardware)
-   [**Flashing with rpiboot**](/guides/pibox/rpiboot)
-   [**Operating System**](/guides/pibox/os)
-   [**GPIO / LED Control**](/guides/pibox/gpio)
-   [**Hardware**](/guides/pibox/hardware)
-   [**Install KubeSail**](/guides/pibox/kubesail)

## About the hardware

The PiBox is a storage server that lets you use a standard operating system, runs Kubernetes, and has expandable storage. Designed for home-hosting and for shipping to customers directly, the PiBox is the perfect small NAS! Check out [pibox.io](https://pibox.io/) for more memory and SSD options.

<img src="/img/pibox.png" width="50%" title="PiBox 2 Mini" /><img src="/img/pibox-ssd-removal.png" width="50%" title="PiBox SSD Removal" />

### Modular Design

The PiBox uses a [Raspberry PI Compute Module 4](https://www.raspberrypi.org/products/compute-module-4/), giving you options of 1, 2, 4, or 8GB RAM, optional WiFi, and up to 32GB of onboard flash storage. The compact design includes 2 powered SATA SSD slots allowing for up to 16TB of expandable storage.

5-bay and desktop HDD compatible models are under development and will be coming soon.

<br />
<img src="/img/pibox-carrier-leaning.png" width="100%" title="PiBox Carrier" />

### Login details

The PiBox ships with the default SSH and SMB username/password of "pi"/"kubesail".

You can access SSH with: `ssh pi@pibox.local`
