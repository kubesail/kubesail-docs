# Custom domains

You can expose your running containers under your own hostname, such as `example.com` rather than under the generated `kubesail.io` hostname. Add as many domains as you'd like by [verifying your domain](https://kubesail.com/domains) in the dashboard.

## Exposing via the UI

Once your domain is verified, you'll find the domain you just added as an option when you click the **Expose to Internet (HTTPS)** button within the **Ports** tab of your Deployment. You may expose any subdomain of the domain you verified, so in the example below, we will expose `api.stuffbydan.com` even though we've only needed to verify the root domain, `stuffbydan.com`.

![[expose via UI](https://kubesail.com/blog-images/custom-domains-ports.png)](https://kubesail.com/blog-images/custom-domains-ports.png)

## Exposing via kubectl

KubeSail currently uses [Ambassador](https://www.getambassador.io/) which allows you to create standard Kubernetes **Services** to route traffic based on hostname. To do this, you'll need to add an ambassador annotation to the **Service**'s metadata, as seen in the below example. Modify the yaml to suit your deployment and hostname, and apply.

```yml
apiVersion: v1
kind: Service
metadata:
  # Name must be the same as in
  # the Ambassador mapping below
  name: nginx-http
  annotations:
    getambassador.io/config: |
      ---
      apiVersion: ambassador/v1
      kind: Mapping
      name: nginx-http.loopdelicious
      prefix: "/"
      service: http://nginx-http.loopdelicious:8080
      host: api.stuffbydan.com
      timeout_ms: 30000
      use_websocket: true
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

KubeSail users automatically get free HTTPS when exposing an application to the internet. For custom domains, you'll need to define which `hosts` the HTTPS certificate is valid for:

```yml
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
          serviceName: my-test-service
          servicePort: 8080
  tls:
  - hosts:
    - test.mywebsite.com
    secretName: testsecret-tls
```
