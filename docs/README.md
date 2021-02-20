# Welcome to the KubeSail Docs

KubeSail (_cube-sail_) makes it easy to host apps from anywhere!

The benefits of installing the KubeSail agent are:

- **Tunneling**: KubeSail will route HTTP/HTTPS traffic from the internet to your machine, bypassing firewalls and automating DNS, etc. Perfect for web-apps at home!
- **Dynamic DNS**: The KubeSail agent automatically assings a dynamic DNS address to your system, useful for SSH, games and other services
- **KubeSail.com**: The Agent connects your cluster to KubeSail.com, allowing for templates, users, SSH login, logs, management and more!
- **Backups**: Once connected, you can backup your Volumes to our cloud, highly encrypted and secure!
- **Repo Builder**: You can select a GitHub repository which will be automatically built and deployed on-commit, on your own hardware!
- **Cluster Features**: We'll assist with critical cluster features such as Metrics, Certificates, Ingress systems and more!

## Getting Started

If you already have a cluster, you can add the KubeSail Agent with the following:

    kubectl create -f https://byoc.kubesail.com/USERNAME.yaml

If you don't have a cluster, Kubernetes can be installed on almost any kind of system. It works best with a spare machine you don't mind leaving on, such as an old PC or a Raspberry PI.

We have guides for: [MicroK8s](https://kubesail.com/blog/microk8s-raspberry-pi), [k3s](https://kubesail.com/blog/k3s-raspberry-pi), and [Hetzner](https://kubesail.com/blog/dedicated-kubernetes-on-hetzner). [Join us in chat](https://gitter.im/KubeSail/community) and we'd love to help build something awesome!


## Deploying apps

Our Repo Builder should help step thru the process of deploying almost any kind of application to Kubernetes. The same process can be done on the commandline as well, with `npx deploy-node-app`. Let us know if you have an app it can't figure out, and we'd love to help support it!

## Cluster Management & Support

We offer custom cluster management, architecture and support. Some of our clients have dozens of clusters shipping out to users each month! We'd love to chat with you about what we can do for your buisiness - please reach out to sales@kubesail.com or [fill out this form](https://kubesail.typeform.com/to/lFZF2r).

## Kubernetes Definitions

Under the hood, KubeSail is built on top of Kubernetes - here are some core Kubernetes definitions you might need to understand to better use the platform:

-   [Deployment](/definitions#deployment)
-   [Service](/definitions#service)
-   [Ingress](/definitions#ingress)
-   [Certificate](/definitions#certificate)
-   [Namespace](/definitions#namespace)
-   [PersistentVolumeClaim](/definitions#persistentvolumeclaim)
-   [Secret](/definitions#secret)

### Kubernetes - what is it good for?

A short list of the complex problems Kubernetes tackles for you:

-   Rolling, zero-downtime deployments with one command
-   Self healing infrastructure (eg: automatically replaces failing AWS systems)
-   Service Discovery via DNS (eg: redis is located at "redis.production.mycluster")
-   Vendor lock-in traps almost entirely removed (Kube can run on anyone's cloud!)
-   An infrastructure that allows easy log aggregation and audits

### Kubernetes - what makes it so hard?

The main pain points with getting started tend to be:

-   Cluster bootstrapping (Which version? Which cloud? Which cluster tool? Hosted or DIY?)
-   Networking layer (A load-balancer per application? An ingress controller?)
-   Cluster-wide security settings (PodSecurityPolicies?) and security updates
-   Designing a Deployment object and other configurations
    \*The missing "complete picture" (What do real, live, in-production configs look like?)
-   Most guides assume you're a veteran Linux user

Kubernetes is widely agreed to be the premier infrastructure API and is expected to maintain that position for quite a while, but the learning curve can be rough. KubeSail intends to fix the Kubernetes onboarding experience.

## FAQ

1.  **Why isnt my ssl certificate being generated?**
    1.  Check your resources usage. Often times the cert-manager pod that gets created does not have enough resources to spin up. The resources it needs are:
        `req.cpu=10m`, `req.mem=64Mi`, `lim.cpu=100m`, `lim.mem=64Mi`
    1.  Check that your DNS points to the correct location so Lets Encrypt can reach the cluster (_this is only applicable to external domains you've added_)
    2.  It's possible your Ingress system is unavailable - A certificate will be generated when it can reach your system, so an unreachable system means no certificate! Try making sure you at least see an "Nginx" branded 404 page when you browse to the URL you're trying to use.

2.  **I'm getting a 503 error and can't access my deployment.**
    1.  Check that your service's label selectors and ports match what is defined in your deployment. You may try deleting the Service and Ingress objects and using the KubeSail "network" tab of your app to expose the desired port.
    2. Double check your Ingress system - typically this is in the `ingress-nginx` or `ingress` namespace, but it can vary depending on your installation. For microk8s, try `microk8s.enable ingress`

3.  **My `kubectl` commands are timing out.**
    1.  Try [upgrading / installing kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) manually -- You may have an version of `kubectl` that ships with docker-desktop for osx which is broken
    2. It's possible your cluster is offline - try checking the `kubesail-agent` namespace and making sure the agent is running. Please let us know in chat if you get stuck here!

4. **My "PersistentVolumeClaims" are never becoming ready**
   1. Storage is not automatically installed in some types of clusters. You should check `kubectl get storageclasses` to ensure you have a storage class. For microk8s, try `microk8s.enable storage`. You will need to delete and re-create any "stuck" VolumeClaims to ensure they are created properly. If you need a more professional storage system, please reach out to us! We're experts at many storage systems including Rook/Ceph.
