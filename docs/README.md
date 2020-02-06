# Welcome to the KubeSail Docs

KubeSail is a hosted Kubernetes provider whose mission is to make the benefits of Kubernetes more accessible to all developers. KubeSail offers a **free managed namespace** with Kubernetes development tools and tutorials making it easy to deploy and host applications.

## Commands

Generate all the boilerplate required for container-based deployments on Kubernetes or Docker.

- `npx deploy-node-app` - [this utility](https://github.com/kubesail/deploy-node-app) deploys an existing Node application to any Kubernetes cluster
- `npx create-node-app` - [this utility](https://github.com/create-node/create-node-app) builds a new directory with presets for a Node API and a front end

## Definitions

- [Certificate](/definitions#certificate)
- [Deployment](/definitions#deployment)
- [Ingress](/definitions#ingress)
- [Namespace](/definitions#namespace)
- [PersistentVolumeClaim](/definitions#persistentvolumeclaim)
- [Secret](/definitions#secret)
- [Service](/definitions#service)

### Kubernetes - what is it good for?

A short list of the complex problems Kubernetes tackles for you:

* Rolling, zero-downtime deployments with one command
* Self healing infrastructure (eg: automatically replaces failing AWS systems)
* Service Discovery via DNS (eg: redis is located at "redis.production.mycluster")
* Vendor lock-in traps almost entirely removed (Kube can run on anyone's cloud!)
* An infrastructure that allows easy log aggregation and audits

### Kubernetes - what makes it so hard?

The main pain points with getting started tend to be:

* Cluster bootstrapping (Which version? Which cloud? Which cluster tool? Hosted or DIY?)
* Networking layer (A load-balancer per application? An ingress controller?)
* Cluster-wide security settings (PodSecurityPolicies?) and security updates
* Designing a Deployment object and other configurations
*The missing "complete picture" (What do real, live, in-production configs look like?)
* Most guides assume you're a veteran Linux user

Kubernetes is widely agreed to be the premier infrastructure API and is expected to maintain that position for quite a while, but the learning curve can be rough. KubeSail intends to fix the Kubernetes onboarding experience.
