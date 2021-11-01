# Bring Your Own Cluster

You can attach any cluster, anywhere - from a Raspberry Pi at home, to a thousand-node cluster on AWS. Attaching a Cluster is accomplished by installing the KubeSail Agent, which is a small [open-source application](https://github.com/kubesail/kubesail-agent).

Once a cluster is attached to KubeSail.com, you can [deploy templates](https://kubesail.com/templates), [attach Repos](https://kubesail.com/repos), and [invite friends and coworkers](https://kubesail.com/clusters) to be either admins or namespaced users, create backups, and more!

KubeSail.com can also forward kube-api and Ingress traffic to your cluster! This allows you to host internet-facing applications on your cluster, even if it does not have a reliable static IP address, and without having to forward ports. HTTPS traffic is kept secure and encrypted from the internet all the way to your cluster's applications - it's never decrypted by KubeSail (or the KubeSail agent).

Read more about [KubeSail Agent](https://github.com/kubesail/kubesail-agent) here, or take a look at a few overview diagrams at the bottom of this page.

# QuickStart
Create a kubesail.com account by signing in with GitHub, then head to the [Clusters](https://kubesail.com/clusters/) section of the dashboard. Click the "Add Cluster" button at the top of the page, and follow the instructions. You will get a 1-line command to install the kubesail agent. Once installed, just click the "Verify Cluster" button. You can now manage applications, install templates, and easily expose HTTP traffic on your cluster.

## Building your Cluster

There are several options for getting a Kubernetes cluster running on any system:

-   [Docker Desktop](/install_kubernetes/#docker-desktop) (Recommended for OSX, Windows)
-   [K3s](/install_kubernetes/#k3s) (Recommended for Linux development)
-   [Microk8s](/install_kubernetes/#microk8s)
-   [Hetzner](https://kubesail.com/blog/dedicated-kubernetes-on-hetzner)
-   [Kubernetes the Hard Way](/install_kubernetes/#kubernetes-the-hard-way)

## Managed cloud services

Running Kubernetes on a managed cloud service is ideal for a **production environment**. These services come with Kubernetes pre-installed. There's several options for provisioning a cluster.

-   EKS
-   GKE
-   Digital Ocean
-   [Chat with us about managed options](https://kubesail.typeform.com/to/lFZF2r)

## Step 2: Link your cluster to KubeSail

Wherever and whatever your cluster is, you can link it to KubeSail from the dashboard under [**Clusters**](https://kubesail.com/clusters/), click **+ Add Cluster**.

![[add new cluster](img/clusters-add-cluster.png)](img/clusters-add-cluster.png)

To add your cluster to KubeSail, apply the configuration file to your cluster using `kubectl`:

    kubectl apply -f https://byoc.kubesail.com/<your-kubesail-username>.yaml

# Using Kubectl with a BYOC cluster

You can fetch a Kubernetes configuration file from https://kubesail.com/config just like with any other cluster.

# Configuring your BYOC Cluster

## Ingress Controller

KubeSail Gateway will forward traffic that it recieves to any connected Agent which is bound for valid domains you own. If the hostname of those requests is the name of your Kubernetes cluster's API, they will be forwarded to Kubernetes. However, if the hostname is _not_ your cluster's address, they will be optionally forwarded to your clusters [Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/). By default, KubeSail agent will look for the [nginx ingress controller](https://kubernetes.github.io/ingress-nginx/), but it should work fine with any ingress system. To control where the traffic is sent, can you configure the following environment variables for the agent. Take a look at the `kubesail-agent` deployment in the `kubesail-agent` namespace:

```
            - name: INGRESS_CONTROLLER_NAMESPACE
              value: default
            - name: INGRESS_CONTROLLER_ENDPOINT
              value: ingress-nginx
```

## MicroK8s

### Resource Usage
Unfortunately, Microk8s is primarily focused on Kubernetes development, in the sense of working on Kubernetes itself. As such, microk8s is very powerful, but requires far more resources than other options, like K3s. On PiBoxes and smaller systems, we recommend K3S!

### Common issues
Make sure to enable a few essential addons that are not enabled by default on Microk8s:

`microk8s enable dns ingress rbac storage`

These are not strictly required but typically recommended! If you're not sure, go ahead and enable all these features. Most features can also be enabled via the "Features" tab of your cluster at https://kubesail.com/clusters

### Common Error Codes:
- **KS_GATEWAY_NO_AGENT_CONNECTED**: The Gateway system will return this code when no agents are connected. Try making sure your cluster is online and if so, double check the `kubesail-agent` namespace and logs. It is safe to delete the agent-installation with `kubectl delete namespace kubesail-agent`, deleting the cluster via the KubeSail.com control panel, and re-installing. No other data or apps on your cluster will be lost. Please let us know if you get stuck!
- **KS_GATEWAY_REJECTED**: The Gateway returns this code when you have created a firewall rule on your systems, and your requesting IP address does not match that firewall
- **KS_GATEWAY_UNSUPPORTED_PROTOCOL**: The Gateway currently only supports IPv4 requests, and it recieved an IPv6 request. Use IPv4 for now - let us know if you need IPv6 support!

# Technical overview:

![[gateway overview](img/gateway-overview.png)](img/gateway-overview.png)

# Request flow:

![[byoc request flow](img/byoc-request-flow.png)](img/byoc-request-flow.png)
