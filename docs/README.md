# KubeSail Docs

**KubeSail** (_cube-sail_) helps developers ship software to their customers. Build a SaaS in minutes with KubeSail Platform, ship software and hardware with PiBox, tunnel traffic and manage on-prem installations with KubeSail Agent, and much more!

## Features

- [**Templates**](/templates): Easily install and share complex software
- [**Tunneling & DNS**](/tunneling): Route traffic from the internet to your machines
- [**Platform**](/platform): Enable customers to pay for your software
- [**Builder**](/builder): Build and deploy GitHub repos on your own hardware or at the edge
- [**Backups**](/backups): Encrypted backups of your (or your customers) volumes
- [**Pibox**](/pibox): A shippable, deploy-ready, cluster-in-a-box

## Attaching a Cluster

KubeSail is built around [Kubernetes](https://kubernetes.io/) and works with any cluster. If you already have a Kubernetes cluster, you can install the **KubeSail Agent** with the following command:

    kubectl create -f https://byoc.kubesail.com/USERNAME.yaml

The KubeSail Agent is a small [open-source agent](https://github.com/kubesail/kubesail-agent) which runs on your cluster and enables the features listed above. Once installed, visit the [KubeSail Dashboard](https://kubesail.com/clusters) to verify and attach your cluster.

## Getting a cluster

#### KubeSail Managed

We specialize in managing Kubernetes clusters and offering expert DevOps support on dedicated hardware, on-prem installations, any major cloud provider. Reach out to us at support@kubesail.com or [book some time to chat](https://calendly.com/kubesail).

#### Cloud Provider guides

- [**Digital Ocean**](/guides/digital-ocean)
- [**Google Cloud**](/guides/gke)
- [**Amazon Web Services**](/guides/aws)

#### Dedicated hardware guides

- [**Hetzner**](https://kubesail.com/blog/dedicated-kubernetes-on-hetzner) (instructions work well for most dedicated hardware providers)

#### Local, embedded or development cluster guides

- [**MicroK8s**](https://kubesail.com/blog/microk8s-raspberry-pi)
- [**k3s**](https://kubesail.com/blog/k3s-raspberry-pi)
