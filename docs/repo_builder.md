# Deploy your app

Once you have a running Kubernetes cluster, you can deploy your containerized applications on top of it. Follow these steps to set up and run a Kubernetes cluster and deploy your first app.

1. [Set up a Kubernetes cluster](#step-1-set-up-a-kubernetes-cluster)
1. [Link your cluster to KubeSail](#step-2-link-your-cluster-to-kubesail)
1. [Deploy from GitHub repository](#step-3-deploy-from-github-repository)

## Step 1: Set up a Kubernetes cluster

There's a few options to set up and run a Kubernetes cluster. You can run Kubernetes on a local machine, cloud, or managed Kubernetes cluster. This allows you to create a Kubernetes solution in either a learning or production environment.

Depending on where you choose to run Kubernetes, the steps to set it up is different.

### Managed cloud services
Running Kubernetes on a managed cloud service is ideal for a **production environment**. These services come with Kubernetes pre-installed. There's several options for provisioning a cluster.

- KubeSail
- EKS
- GKE
- Digital Ocean

### Managing your own cluster

Installing Kubernetes on your own machine, a dedicated computer, or Raspberry Pi is ideal for a **learning environment**. There's several options for running Kubernetes locally.

- [Docker Desktop](/install_kubernetes/#docker-desktop)
- [Microk8s](/install_kubernetes/#microk8s)
- [K3s](/install_kubernetes/#k3s)
- [Kubernetes the Hard Way](/install_kubernetes/#kubernetes-the-hard-way)

## Step 2: Link your cluster to KubeSail

Install the KubeSail agent on your cluster to enable two main functions:

- Manage apps on your cluster
- Expose apps to the internet

From the KubeSail dashboard under [**Clusters**](https://kubesail.com/clusters/), click **+ Add Cluster**.

![[add new cluster](img/clusters-add-cluster.png)](img/clusters-add-cluster.png)

To add your cluster to KubeSail, apply the configuration file to your cluster using `kubectl`:

    kubectl apply -f https://byoc.kubesail.com/<your-kubesail-username>.yaml

## Step 3: Deploy from GitHub repository

From the KubeSail dashboard under [**Repos**](https://kubesail.com/repos), click **Connect New Repository**, and select which repo you want to install the KubeSail DeployBot. You can grant access to selected repositories within the user or organization's account.

![[give deploybot permissions](img/deployboy-permissions.png)](img/deployboy-permissions.png)

Once you grant KubeSail access to a GitHub repository, it appears under **Repos** within the KubeSail dashboard. 

Select the newly added repository to view the suggested pipeline. Pick a branch to build and a Kubernetes context from the dropdowns, and then click **Build Now**. You can view the build logs beneath your pipeline. 

![[build pipeline](img/repos-pipeline-build.png)](img/repos-pipeline-build.png)

Once your app successfully builds and deploys, it appears under **Apps** within the KubeSail dashboard.
