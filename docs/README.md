# Welcome to the KubeSail Docs

KubeSail makes it easy to Host apps at home (or anywhere!)

When you attach a cluster to KubeSail, you can:

- Forward traffic from the internet to your Apps, bypassing firewalls and avoiding dynamic DNS issues!
- Install templates: Install, build and share templates for useful home hosting applications
- Manage your apps: stream logs, update and re-deploy
- Manage your servers: backup data, backup configurations, SSH into nodes and more!
- Invite friends and co-workers to manage your servers as well!

KubeSail is powered by Kubernetes - for experts this means you'll be right at home, with complete control. For beginners, this means you'll be learning useful, re-usable knowledge, not our special KubeSail(tm) knowledge!

The best place to start is to setup a Cluster!

If you already have a cluster, you can add the KubeSail Agent with the following:

    kubectl create -f https://byoc.kubesail.com/USERNAME.yaml

We have guides for: [MicroK8s](https://kubesail.com/blog/microk8s-raspberry-pi), [k3s](https://kubesail.com/blog/k3s-raspberry-pi), and [Hetzner](https://kubesail.com/blog/dedicated-kubernetes-on-hetzner), but have installed KubeSail Agent on just about any kind of machine you can imagine! [Join us in chat](https://gitter.im/KubeSail/community) and we'd love to talk about building something awesome!


## Deploying apps

We're building [deploy-node-app](https://github.com/kubesail/deploy-node-app), which you can use like `npx deploy-node-app`, which steps through the process of creating a deployable image from any common Node.js application - it works with other languages and static-sites too!

We're also working hard on making our template editor easy-to-use, and we'd love your feedback! Please join us in our [Gitter chat](https://gitter.im/KubeSail/community) if have any feedback for us!

## Cluster Management

We offer custom cluster management as well - particularly with Edge hosting! Some of our clients have dozens of clusters shipping out to users each month! We'd love to chat with you about what we can do for your buisiness - please reach out to sales@kubesail.com or [fill out this form](https://kubesail.typeform.com/to/lFZF2r) and we'll get back to you asap!

## Kubernetes Definitions

-   [Certificate](/definitions#certificate)
-   [Deployment](/definitions#deployment)
-   [Ingress](/definitions#ingress)
-   [Namespace](/definitions#namespace)
-   [PersistentVolumeClaim](/definitions#persistentvolumeclaim)
-   [Secret](/definitions#secret)
-   [Service](/definitions#service)

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
1.  **I'm getting a 503 error and can't access my deployment.**
    1.  Check that your service's label selectors and ports match what is defined in your deployment
1.  **My `kubectl` commands are timing out.**
    1.  Try [upgrading / installing kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) manually -- You may have an version of `kubectl` that ships with docker-desktop for osx which is broken
