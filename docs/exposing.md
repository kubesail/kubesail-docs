# Exposing your app

KubeSail provides access to vanilla Kubernetes objects, like **Ingress** and **Certificate** objects.

## Domains
You'll have a number of built-in KubeSail domains to use.

- Domains that end with **k8g8.com** are "tunneled" addresses, which use our Gateway/Agent system to proxy traffic to you. Tunneling currently only works with HTTP and HTTPS traffic.
- Domains that end with **ksdns.io** are "Dynamic DNS" addresses, which point at your Public IP address. This may require Port-Forwarding and other firewall changes on your local network - this can be used with any kind of traffic, but is most useful for non HTTP, such as SSH or games servers.

## Ingress

An [**Ingress**](/definitions/#ingress) is a Kubernetes object which tells the cluster how to send external traffic to a particular [**Service**](/definitions/#service).

<img src="https://kubesail.com/blog-images/blog-tls-1.png" style="width: 400px; margin: 30px auto;" />

An **Ingress** can serve either TCP or HTTP traffic. For HTTP services, it typically includes three pieces of information:

- The _Hostname_ which identifies this traffic
- The **Service** name and port which traffic will be sent to
- For HTTPS, a **Certificate** for encryption

KubeSail enables the vanilla Kubernetes API, so most guides for creating an **Ingress** should work. The KubeSail dashboard also helps you create an **Ingress**. Click on the **Ports** section of any deployment and choose **Expose to Internet**.

## Certificates

Certificates use the [cert-manager](https://github.com/jetstack/cert-manager) project to automatically issue free certificates from [Let's Encrypt](https://letsencrypt.org/). Because KubeSail uses the [NGINX Ingress Controller](https://github.com/kubernetes/ingress-nginx), creating an [**Ingress**](/definitions/#ingress) object in your namespace also automatically creates a [**Certificate**](/definitions/#certificate) object and associated [**Secret**](/definitions/#secret) if they don't already exist.

Here is a basic **Ingress** object which creates a web-accessible site:

```yml
#?filename=basic-ingress.yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: basic-ingress
spec:
  rules:
  - http:
      paths:
      - backend:
          service:
            name: my-test-service
            port:
              name: 8080
        pathType: ImplementationSpecific
    tls:
    - hosts:
      - new.my-cluster.my-user.usw1.k8g8.com
      secretName: new-ingress
```

Check your **Certificates** with `kubectl get certificates`. This certificate will automatically be used and HTTPS should "just work".

When you expose your running containers under [your own hostname](./domains.md), you'll need to further define the HTTPS certificate is valid for which `hosts`.
