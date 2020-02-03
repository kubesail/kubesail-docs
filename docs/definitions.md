# Definitions

> There are 2 hard problems in computer science: cache invalidation, **naming things**, and off-by-1 errors.
>
> -- Leon Bambrick

## Certificate

A **certificate** is a request for an X.509 Certificate to be issued from the [cert-manager](https://github.com/jetstack/cert-manager) project.

```yml
#?filename=test-certificate.yaml
apiVersion: certmanager.k8s.io/v1alpha1
kind: Certificate
metadata:
  name: acme-crt
spec:
  secretName: acme-crt-secret
  dnsNames:
  - foo.example.com
  - bar.example.com
  acme:
    config:
    - http01:
        ingressClass: nginx
      domains:
      - foo.example.com
      - bar.example.com
  issuerRef:
    name: letsencrypt-prod
    # We can reference ClusterIssuers by changing the kind here.
    # The default value is Issuer (i.e. a locally namespaced Issuer)
    kind: Issuer
```

This **Certificate** will tell cert-manager to attempt to use the Issuer named `letsencrypt-prod` to obtain a certificate key pair for the `foo.example.com` and `bar.example.com` domains. If successful, the resulting key and certificate will be stored in a secret named `acme-crt-secret` with keys of `tls.key` and `tls.crt` respectively. This secret will live in the same namespace as the **Certificate** resource.

### Additional resources

- [Certificate documentation from cert-manager](https://docs.cert-manager.io/en/latest/reference/certificates.html)

## Deployment

In Kubernetes, a **Deployment** is an object which describes how an application is deployed. It consists of a few basic pieces of data, including some _metadata_ like the name of your deployment (for example one of ours is "nginx", but the name is arbitrary), a _selector_, which is a set of arbitrary labels, and a _template_, which defines the **Pods** in this deployment.

A **Deployment** is one of the core building blocks in Kubernetes, and is suitable for almost all application hosting needs, but the term "deployment" can be confusing and a bit overused - so it's important to understand that you do not need to create a new **Deployment** to deploy new code. Take an example nginx server:

```yml
#?filename=deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - image: nginx:1.15
          name: nginx
          ports:
            - containerPort: 80
              name: http
```

Should we want to upgrade to `nginx:1.16`, we update the `image` string on the deployment. You can do this on the command line with:

```bash
kubectl edit deployment DEPLOYMENT_NAME
```

Or more directly:

```bash
kubectl set image deployment nginx nginx=nginx:1.16
```

You might have noticed `replicas: 1`, which gives a hint at some of the ways you can ensure that the upgrade we just performed is done safely, with _zero downtime_, and no compromises.

### Real-world Example

Here is a real-world example of the API Deployment definition for `kubesail.com` - not every option in the Deployment API is used, but many of these options help us accomplish truly zero-downtime deployments. 

```yaml
#?filename=production-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  selector:
    matchLabels:
      app: api
      tier: service
  minReadySeconds: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2
      maxUnavailable: 0
  replicas: 3
  template:
    metadata:
      labels:
        app: api
        tier: service
        logs: json
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - topologyKey: kubernetes.io/hostname
      volumes:
        - name: ssl-volume
          secret:
            secretName: examplecom
      terminationGracePeriodSeconds: 15
      containers:
        - name: api
          image: examplecom:latest
          imagePullPolicy: Always
          command: ["node", "src/api"]
          lifecycle:
            preStop:
              exec:
                command: ["sleep", "15"]
          ports:
            - name: https-ports
              containerPort: 8000
          envFrom:
            - secretRef:
                name: api
          env:
            - name: LOG_LEVEL
              value: info
          volumeMounts:
            - name: ssl-volume
              mountPath: /app/secrets
          resources:
            requests:
              cpu: 50m
              memory: 100Mi
            limits:
              cpu: 2
              memory: 1500Mi
          readinessProbe:
            httpGet:
              path: /health
              port: https-ports
              scheme: HTTPS
              httpHeaders:
                - name: Host
                  value: api.examplecom.com
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /healthz
              port: https-ports
              scheme: HTTPS
              httpHeaders:
                - name: Host
                  value: api.examplecom.com
            initialDelaySeconds: 10
            periodSeconds: 10
```

### Additional resources

- [The official Kubernetes guides](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Kubernetes deployment strategies by container-solutions](https://container-solutions.com/kubernetes-deployment-strategies/)
- [A very gentle guide from Mirantis](https://www.mirantis.com/blog/introduction-to-yaml-creating-a-kubernetes-deployment)

## Ingress

An **Ingress** is a Kubernetes object which tells the cluster how to send external traffic to a particular **Service**.

<img src="https://kubesail.com/blog-images/blog-tls-1.png" style="width: 400px; margin: 30px auto;" />

Here is an example Kubernetes **Ingress** Object:

```yml
#?filename=test-ingress.yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: test-ingress
spec:
  rules:
  - http:
      paths:
      - path: /testpath
        backend:
          serviceName: test
          servicePort: 80
```

An **Ingress** can serve either TCP or HTTP traffic. For HTTP services, an **Ingress** typically includes 3 pieces of information:

- The _Hostname_ which identifies this traffic
- The **Service** name and port which traffic will be sent to
- For HTTPS, a **Certificate** for encryption

### Additional resources

- [Kubernetes documentation for Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)

## Namespace

A **Namespace** is a logical group for application environments - staging, qa, production. A **Namespace** isolates containers within it from containers outside. You can think of a **Namespace** a bit like an IP network, in that applications typically have access to other resources within their same **Namespace**. 

KubeSail provides you with a **Namespace** on a shared cluster, and is one of the ways we isolate your applications from those of other users.

There isn't typically much to a **Namespace** definition, simply a name:

```yml
#?filename=namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: my-namespace
```

## PersistentVolumeClaim

A **PersistentVolumeClaim** is a request for storage - it asks the Kubernetes Cluster for a particular type of storage which it can use as a Volume. After submitting a **PersistentVolumeClaim**, the Kubernetes Cluster will provision a **PersistentVolume**, which will be bound to your **PersistentVolumeClaim** (sometimes called a PVC).

Why are there both **PersistentVolumes** and **PersistentVolumeClaims**?

When a **PersistentVolumeClaim** is deleted by a user, it follows a defined policy regarding cleaning up the actual data on the **PersistentVolume** (which you can think of as the actual disk itself). By default, **PersistentVolumes** are _not deleted_, which reflects Kubernetes' safety-first attitude and design.

## Secret

A **Secret** is a file, set of keys and values, or blob of data which can be provided to particular pods as environment variables, or mounted as files.

Here's a simple `Opaque` type secret:

```yml
#?filename=password.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-pass
type: Opaque
stringData:
  password: SECRET_PASSWORD_GOES_HERE
```

Secrets can also be [encrypted at rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/) and managed by other tools like [Vault](https://blog.kubernauts.io/managing-secrets-in-kubernetes-with-vault-by-hashicorp-f0db45cc208a).

### Additional resources

- [Kubernetes Secrets documentation](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Managing secrets by WeaveWorks](https://www.weave.works/blog/managing-secrets-in-kubernetes)

## Service

A Kubernetes **Service** is an object which describes how to access your applications. You can think of a **Service** a bit like a DNS name, a firewall rule, and a load balancer all in-one - because it is. **Services** "select" applications to point at via their `selector` tag. You'll notice this matches our definition on the **Deployment** example page.

```yml
#?filename=nginx-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-http
spec:
  type: ClusterIP
  ports:
  - name: tcp
    port: 80
  selector:
    app: nginx
```

Once defined, all pods in the same **Namespace** as this pod can automatically access the NGINX server via the address: `http://nginx-http`. Many services can select the same pods, and pods can be exposed by multiple services. For example, we're only exposing port 80 here. Another service might expose the 443 port later.

Services have a number of "types" of Kubernetes Services:

- **ClusterIP**: this type of service is only reachable from inside the cluster and is the default type.
- **NodePort**: this service type selects a static port number on the **Node**, potentially allowing access to the service from the internet.
- **LoadBalancer**: this service requires a Cloud Provider plugin which will create an actual Cloud LoadBalancer resource for you. Kubernetes then actively manages the LoadBalancer, ensuring it points at the right nodes and the right ports.

### Additional resources

- [Kubernetes documentation for Services](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Exposing your app, a tutorial](https://kubernetes.io/docs/tutorials/kubernetes-basics/expose/expose-intro/)
- [When should I use what kind of service?](https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0)
