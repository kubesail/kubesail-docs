# AWS Kubernetes Cluster

### Managed

KubeSail offers completely managed clusters in your AWS account via sub-accounts. Schedule a [chat with us](https://calendly.com/kubesail) and we can build and manage your customer cluster on AWS.

### Unmanaged Guides

- [Build using `eksctl`](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html) (recommended)
- [Build using AWS Console](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html)
- [Build using KubeSpray](https://www.altoros.com/blog/installing-kubernetes-with-kubespray-on-aws/) (advanced)

### Attach Cluster to KubeSail

If you've used `eksctl`, you should be ready to use your cluster using `kubectl` automatically. You can check by running a command like: `kubectl get nodes` to ensure your cluster is healthy.

To attach your cluster to KubeSail, visit [the Clusters portal](https://kubesail.com/clusters) and click **Add cluster**, or simply run:

    kubectl create -f https://byoc.kubesail.com/<USERNAME>.yaml

You should see the cluster appear in the clusters panel. Give it a name and click **Verify Cluster**:

<img src="/img/verify-new-aws-cluster.png" width="100%" title="Verify new Cluster" />

### Use Cluster with KubeSail Platform

After creating a [Platform](/platform), click on the **Cluster** line and select the cluster you want apps deployed to. Your verified cluster should show up in the list!

<img src="/img/select-platform-cluster.png" width="100%" title="Verify new Cluster" />

When customers pay through the customer portal, they will now have their apps deployed in new namespaces on this cluster. Use the **Customers** tab to view and manage them.
