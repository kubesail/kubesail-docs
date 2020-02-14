# Custom domains

You can expose your running containers under your own hostname, such as `example.com` rather than under the generated `kubesail.io` hostname. Add as many domains as you'd like by [verifying your domain](https://kubesail.com/domains) in the dashboard.

## Exposing via the UI

Once your domain is verified, you'll find the domain you just added as an option when you click the **Expose to Internet (HTTPS)** button within the **Ports** tab of your deployment. You may expose any subdomain of the domain you verified, so in the example below, we will expose `api.stuffbydan.com` even though we've only needed to verify the root domain, `stuffbydan.com`. Then you will need to point your domain `api.stuffbydan.com` to your namespace `pastudan.kubesail.io` using a CNAME or ALIAS record if you haven't done so already.

<img src="https://kubesail.com/blog-images/custom-domains-ports.png" style="width: 400px; margin: 30px auto;" />

## Exposing via kubectl

KubeSail allows you to create standard Kubernetes **Services** to route traffic based on hostname. Modify the yaml to suit your deployment and hostname, and then **apply** your updates using kubectl.

```yml
#?filename=domain-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app
spec:
  ports:
  - name: tcp
    port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: nginx
  type: ClusterIP
```

## HTTPS for certificates

KubeSail users automatically get free HTTPS when exposing an application to the internet. For custom domains, you'll need to define the HTTPS certificate is valid for which `hosts`.

```yml
#?filename=domain-svc.yaml
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
    secretName: testsecret-tls
```
