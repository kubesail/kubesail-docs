# Tunneling

**Tunneling** and **DNS** services allow internet traffic to reach your clusters.

### Tunneling

The KubeSail Agent automatically maintains a secure tunnel between your cluster and the KubeSail Gateway, bypassing any firewalls and allowing simple and reliable access to your apps:

<img src="/img/tunneling.png" title="Tunneled Traffic" />

You'll be able to access your cluster with a domain like "mycluster.username.region.**k8g8.com**". All **k8g8.com** domains are tunneled: the traffic is sent through our gateway system and routed to the Agent on your cluster. This is perfect for home-hosting, IoT and simple use-cases where the cluster may move or have an unreliable connection to the internet or are behind a firewall.

### Dynamic DNS

The KubeSail Agent will also periodically set a Dynamic DNS address.

<img src="/img/tunneling-dns.png" title="DNS Traffic" />

An address like "mycluster.username.region.**ksdns.io**" will resolve to your cluster's IP address. All **ksdns.io** domains use Dynamic DNS. Make sure your firewall is configured properly! This is useful for non-HTTP services such a game-servers and voice applications.

### Direct Access

For heavier traffic situations, or for example when using a Cloud Provider. You may want to directly access your cluster via a Load Balancer - This works normally and would bypass the KubeSail agent and connect directly to your Ingress controller. [Schedule a chat with us](https://calendly.com/kubesail/15min) and we can help design a solution!

### Custom domains

You can expose your running containers under your own hostname, such as `home.example.com` rather than under the generated `k8g8.com`/`ksdns.io` hostnames. Add as many domains as you'd like by [verifying your domain](https://kubesail.com/domains) in the dashboard. Use a CNAME or ALIAS record, say `home.example.com`, which points at either your Tunneled or Dynamic DNS Addresses.

### Tunneling Details

The Agent and Gateway maintain a persistent connection, which is used to tunnel HTTP and HTTPS requests from the Gateway to the Agent. All KubeSail Gateway addresses end with `k8g8.com`.

When an HTTPS request is received by the Gateway, we inspect the SNI header packets to determine the hostname and pass the encrypted request (we don't have the certificate!) to your KubeSail Agent, which in turn routes the request to your Ingress Controller. See [kubesail/kubesail-agent](https://github.com/kubesail/kubesail-agent) for more info! HTTP traffic is also forwarded, based on the `HOST` header.

### HTTPS & Certificates

You'll need to make sure you've installed [cert-manager](https://cert-manager.io/docs/). You can install it with:

```sh
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.3.0/cert-manager.yaml
```

To receive `Certificates`, you'll need a `ClusterIssuer` and an `Ingress` object.

### ClusterIssuer

A `ClusterIssuer` is a Document that tracks an account with Let's Encrypt, which will allow you to `Order` a `Certificate`. See [the docs](https://docs.cert-manager.io/en/release-0.11/reference/clusterissuers.html) for more. A `ClusterIssuer` called "letsencrypt" should be automatically created by the KubeSail agent - as long as this exists you should be good to go!

### Ingress

An `Ingress` object routes HTTP/HTTPS traffic to a `Service` based on a hostname. These documents are automatically read by the KubeSail Agent. If you create an `Ingress` for any domains verified in your [Domains portal](https://kubesail.com/domains), traffic will be passed from the Gateway to the Agent.

Also note the `tls` section, which will cause a `Certificate` to be created automatically!

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: domain-ingress
spec:
  rules:
  - host: test.mywebsite.com
    http:
      paths:
      - backend:
          serviceName: my-app
          servicePort: 8080
  tls:
  - hosts:
    - test.mywebsite.com
    secretName: mywebsite-cerfificate
```
