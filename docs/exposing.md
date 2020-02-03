# Exposing your app

KubeSail provides access to vanilla Kubernetes objects, like **Ingress** and **Certificate** objects.

## Ingress

An **Ingress** is a Kubernetes object which tells the cluster how to send external traffic to a particular **Service**.

<img src="https://kubesail.com/blog-images/blog-tls-1.png" style="width: 400px; margin: 30px auto;" />

An **Ingress** can serve either TCP or HTTP traffic - for HTTP services it typically includes three pieces of information:

- The _Hostname_ which identifies this traffic
- The **Service** name and port which traffic will be sent to
- For HTTPS, a **Certificate** for encryption

KubeSail enables the vanilla Kubernetes API, so most guides for creating an **Ingress** should work. The KubeSail dashboard also helps you create an **Ingress** - click on the **Ports** section of any deployment and choose **Expose to Internet**.

## Certificates

Certificates use the [cert-manager](https://github.com/jetstack/cert-manager) project to automatically issue free certificates from [Let's Encrypt](https://letsencrypt.org/). Because KubeSail uses the [NGINX Ingress Controller](https://github.com/kubernetes/ingress-nginx), creating an **Ingress** object in your namespace also automatically creates a **Certificate** object and associated **Secret** if they don't already exist.

Here is a basic **Ingress** object which creates a web-accessible site using your free `*.kubesail.io` domain:

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
          serviceName: my-test-service
          servicePort: 8080
```

Check your **Certificates** with `kubectl get certificates`. This certificate will automatically be used and HTTPS should "just work".

When you expose your running containers under [your own hostname](./domains.md), you'll need to further define which `hosts` the HTTPS certificate is valid for.
