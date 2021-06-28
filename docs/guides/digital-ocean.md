# Digital Ocean Kubernetes Cluster

### Managed

KubeSail offers completely managed clusters in your Digital Ocean account. Schedule a [chat with us](https://calendly.com/kubesail) and we can build and manage your customer cluster.

### Creating a new Cluster

Select "Kubernetes" from the Create dropdown button in the Digital Ocean dashboard. The default options are ok in most cases. The cluster will take a few minutes to spin up.

<img src="/img/do-create-cluster.png" width="100%" title="Create new Cluster" />

You will most likely want to add **Autoscaling** to handle increased load as more of your customers sign up. This is done in the **Nodes** tab, by configuring the settings of the node pool.

<img src="/img/do-nodes-options.png" width="100%" title="Nodes -> Autoscaling" />

Select the "Autoscale" option, and set a reasonable max number of nodes. 10 is fine in most cases.

<img src="/img/do-nodes-autoscale.png" width="100%" title="Autoscaling Options" />

### Attach Cluster to KubeSail

Under the "Overview" tab, you can download your `kubectl` config file in order to access your cluster via the command line. Download this file and move it to `~/.kube/config`. You can create the `~/.kube` directory if it does not yet exist.

<img src="/img/do-download-config.png" width="100%" title="Autoscaling Options" />

You can check that you have access and ensure your cluster is healthy by running a command like: `kubectl get nodes`.

To attach your cluster to KubeSail, visit [the Clusters portal](https://kubesail.com/clusters) and click **Add cluster**, or simply run:

    kubectl create -f https://byoc.kubesail.com/<USERNAME>.yaml

You should see the cluster appear in the clusters panel. Give it a name and click **Verify Cluster**:

<img src="/img/verify-new-aws-cluster.png" width="100%" title="Verify new Cluster" />

### Use Cluster with KubeSail Platform

After creating a [Platform](/platform), click on the **Cluster** line and select the cluster you want apps deployed to. Your verified cluster should show up in the list!

<img src="/img/select-platform-cluster.png" width="100%" title="Verify new Cluster" />

When customers pay through the customer portal, they will now have their apps deployed in new namespaces on this cluster. Use the **Customers** tab to view and manage them.
