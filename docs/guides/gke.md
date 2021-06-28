# Google Cloud Kubernetes Cluster

### Managed

KubeSail offers completely managed clusters in your Google Cloud account. Schedule a [chat with us](https://calendly.com/kubesail) and we can build and manage your customer cluster.

### Creating a new Cluster

Select "Kubernetes Engine" -> "Clusters" from the main menu. Select "Create" from the dropdown. KubeSail works with either cluster mode, but we recommend "Autopilot" in most cases. Select "Configure" and then "Create" on the next page. The default options for the cluster are fine. The cluster will take a few minutes to spin up.

<img src="/img/gke-create-cluster.png" width="100%" title="Create new Cluster" />


### Attach Cluster to KubeSail

To connect your new cluster to KubeSail, you will need to install the KubeSail Agent. This can be done by clicking the "Connect" button in the main cluster settings page.

<img src="/img/gke-connect-cloud-shell.png" width="100%" title="Connect via Cloud Shell" />

Once the shell opens, hit the "Enter" key to run the pre-filled command, and the shell will fetch credentials for accessing your cluster. You will need to authorize access.

<img src="/img/gke-authorize.png" width="100%" title="Authorize Cloud Shell" />

Once this completes, you can install the KubeSail agent by running

    kubectl create -f https://byoc.kubesail.com/<USERNAME>.yaml

and replacing `<USERNAME>` with your KubeSail username.

<img src="/img/gke-attach-kubesail.png" width="100%" title="Attach KubeSail" />

You should see the cluster appear in the [the Clusters portal](https://kubesail.com/clusters). Give it a name and click **Verify Cluster**:

<img src="/img/verify-new-aws-cluster.png" width="100%" title="Verify new Cluster" />

### Use Cluster with KubeSail Platform

After creating a [Platform](/platform), click on the **Cluster** line and select the cluster you want apps deployed to. Your verified cluster should show up in the list!

<img src="/img/select-platform-cluster.png" width="100%" title="Verify new Cluster" />

When customers pay through the customer portal, they will now have their apps deployed in new namespaces on this cluster. Use the **Customers** tab to view and manage them.
