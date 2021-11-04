# Local / Bare Metal clusters

KubeSail is designed to work with any Kubernetes cluster, including bare metal and development boxes. This guide covers setting up a PiBox or Docker for Desktop for running Kubernetes apps locally.

## PiBox - Custom Hardware, Shipping Soon

Designed for simplicity, KubeSail now ships a custom low-cost cluster, pre-installed with Kubernetes and the KubeSail agent. The design is based on the [Raspberry Pi 4 Compute Module](https://datasheets.raspberrypi.org/cm4/cm4-product-brief.pdf), includes 2 expandable SATA SSD ports, and costs $250. PiBox is ideal for home and small office use, and makes it simple to take advantage of 1-click installable KubeSail templates and backups.

Pre-order one now [on Kickstarter](https://www.kickstarter.com/projects/pastudan/pibox-a-modular-raspberry-pi-storage-server) or learn more at [pibox.io](https://pibox.io).

<img src="/img/pibox.png" width="100%" title="Docker Desktop - Enable Kubernetes" />

## Docker for Desktop

<img src="/img/docker-desktop-kube-enable.png" width="100%" title="Docker Desktop - Enable Kubernetes" />

Docker Desktop for Mac and Windows now ships with Kubernetes, making it the simplest way to get a development cluster online.

After enabling Kubernetes in the Docker Desktop settings panel, visit [the Clusters portal](https://kubesail.com/clusters) and click **Add cluster**, or simply run:

    kubectl create -f https://byoc.kubesail.com/<USERNAME>.yaml
