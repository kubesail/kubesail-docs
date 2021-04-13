# KubeSail Docs

**KubeSail** (_cube-sail_) allows you to host applications anywhere: at home, in the cloud, or in your customers office. We build tools for developers that make it easy to use and distribute software - an app store for server-side software!

### Features

- [**Templates**](/templates): Easily install and share complex software
- [**Tunneling & DNS**](/tunneling): Route traffic from the internet to your machines
- [**Platform**](/platform): Enable customers to pay for your software
- [**Builder**](/builder): Build and deploy GitHub repos on your own hardware or at the edge
- [**Backups**](/backups): Backup your volumes to our cloud, encrypted and secure
- [**Pibox**](/pibox): A shippable, deploy-ready, cluster-in-a-box

### Attaching a Cluster

KubeSail is built around [Kubernetes](https://kubernetes.io/). If you already have a Kubernetes cluster, you can install the **KubeSail Agent** with the following command:

    kubectl create -f https://byoc.kubesail.com/USERNAME.yaml

The KubeSail Agent is a small [open-source agent](https://github.com/kubesail/kubesail-agent) which runs on your cluster and enables the features listed above.

### Getting a cluster

If you don't have a cluster, we have guides for creating one with [MicroK8s](https://kubesail.com/blog/microk8s-raspberry-pi), [k3s](https://kubesail.com/blog/k3s-raspberry-pi), and on Cloud providers like [Hetzner](https://kubesail.com/blog/dedicated-kubernetes-on-hetzner). We also build and manage custom clusters with specialized requirements. [Schedule a chat with us](https://calendly.com/kubesail/15min) and we'd love to help build something awesome!

