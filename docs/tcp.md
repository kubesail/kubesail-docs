# Exposing TCP Services

While the KubeSail UI Helps you easily expose HTTP services, exposing TCP services using Kubesail is currently more manual and requires using the `kubectl` CLI tool. This page will guide you through the process.

> NOTE To prevent abuse, exposing TCP traffic on a shared cluster is only available to users of paid KubeSail plans

## Allowing external traffic into your namespace

By default, KubeSail namespaces are isolated from the outside world with a [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) for security reasons. We will need to add a new Network Policy that specifically allows traffic to your application. The easiest way to do this is to load the following Template and modify the values in the `ports:` section. For example, if my Factorio container listens on port `34197`, then I would change the `spec` -> `ingress` -> `ports` -> `port` section to `34197`, and then hit apply.

Open this [Template](https://kubesail.com/template/PastuDan/External%20TCP%20Network%20Policy), modify, and apply.

![Network Policy](img/tcp-service-networkpolicy.png)


## Creating your service

You will need to create a `NodePort` Service pointed to your application. The easiest way to do this is to click the "Expose Inside Cluster" button on the "Network" tab of your app. After clicking "Save", click the "edit yaml" link.

![Edit Yaml of Service](img/tcp-service-edit-yaml.png)

In the editor on the right, we will want to change to the `type` to `NodePort` and click the **Apply** at the top right.
The editor will load in the the updated resource's YAML from Kubernetes. Note the port number under `spec` -> `ports` -> `nodePort`. That will be used in conjuction with the hostname `ext-a.kubesail.io` to access your application.

![Editor](img/tcp-service-editor.png)

For example, if my Service contained `nodePort: 45502`, then I would access my service at `ext-a.kubesail.io:45502`.
