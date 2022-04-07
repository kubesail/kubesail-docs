# Getting Started

This guide will step you through the process of self-hosting an app. We'll use [Photostructure](https://photostructure.com/) as our example app. At the end of the guide, you'll have a server you own up and running on which you can install apps, host websites, and backup your data. You can use our free-tier and bring your own computer to follow this guide completely for free!

## 1. Attach a computer to KubeSail

The first question when self-hosting is: What computer am I going to use as my server?

### I'll use...

=== "A PiBox"
[The PiBox](https://pibox.io) is our custom-designed self-hosting hardware. Order a PiBox at [pibox.io](https://pibox.io), plug it in, scan the QR code on the screen, and start self-hosting! See [the PiBox documentation](/pibox) for more details!

    <img src="/img/pibox.png" width="50%" title="PiBox 2 Mini" /><img src="/img/pibox-ssd-removal.png" width="50%" title="PiBox SSD Removal" />

    ### Plug and Play

    1. Plug in Ethernet
    2. Plug in Power
    3. Toggle the switch located on the power cable
    4. Grab a coffee (or just wait about 30 seconds)
    5. Scan the QR code on the screen to continue!

    <img src="/img/display-qr2.png" width="50%" title="PiBox 2 QR Code setup" />

    If for some reason setup fails, please let us know! You can toggle the power to the PiBox in order to get a new QR code.

=== "A spare PC I own"
KubeSail works on almost any PC, but we recommend a computer with at least the following:

    - **4GB RAM** (8GB recommended)
    - **40GB disk space** (80GB+ recommended)
    - **Wired internet connection** (recommended)

    ### a. Install Linux

    We recommend [Debian 11](https://debian.org), although most Linux distributions should work fine. See [the Debian install guide](https://wiki.debian.org/DebianInstall) or this [tutorial from tecadmin](https://tecadmin.net/how-to-install-debian-11/). If you need a hand, our community might be able to help: [join discord](https://discord.gg/N3zNdp7jHc).

    ### b. Install Kubernetes

    We recommend [k3s](https://k3s.io) which is very easy to install:

    ```
    curl -sfL https://get.k3s.io | sh -
    ```

    ### c. Attach to KubeSail

    Visit [the KubeSail Dashboard](https://kubesail.com/dashboard), click "Clusters", then **Add Cluster**. Choose "Bring your Own" and run the command that begins with `kubectl create -f`. Your new cluster should appear on the dashboard in a few moments!

=== "A Cloud Provider"
We have a few guides for various popular cloud providers:

    - [AWS](/guides/aws)
    - [Digital Ocean](/guides/digital-ocean)
    - [Google Cloud](/guides/gke)

    You should be able to use almost any provider of cloud or dedicated servers with KubeSail, so long as your server(s) run Linux and Kubernetes, you should be good. Check the "A spare PC I own" tab for generic setup instructions.

## 2. Verify Cluster

If you've scanned the QR code on your PiBox, you can skip this step, otherwise, choose a name for your server and click **Verify Cluster**! This will attach your server to KubeSail. Checkout the [core features](/) or just install [some apps and get started](https://kubesail.com/templates)!

<img src="/img/verify-cluster.jpg" title="Verify Cluster" />

## 3. Install an App

Visit the [Template Store](https://kubesail.com/templates), where you can browse a selection of easy-to-install self-hosting apps. The majority of the apps in our Template Store are open-source applications, so please remember to support the authors of the apps you like! We plan on offering ways to directly donate to creators you like in the future.

<img src="/img/templates.jpg" title="Verify Cluster" />

Let's choose [Photostructure](https://kubesail.com/template/erulabs/photostructure), a lightweight photo-manager that works great with the [KubeSail App](https://apps.apple.com/us/app/kubesail/id1609464147).

<img src="/img/templates-photostructure.jpg" title="Photostructure - a light-weight photo manager" />

Click **Launch Template**, wait a moment while the app installs, and you should see a usable URL:

<img src="/img/templates-photostructure-ingress.jpg" title="Photostructure Ingress" />

Click and link and log-in using the username/password on the Template install page.

Without any additional configuration, the [KubeSail App](https://apps.apple.com/us/app/kubesail/id1609464147) will sync your devices photos into Photostructure's `photos` Volume, and should appear in the Photostructure interface within a few moments!

There are more apps available in the [Template Store](https://kubesail.com/templates), and we're focused on adding more great self-hosted apps as quickly as we can. If you have any requests, please let us know!

## 4. Congratulations!

<img src="/img/its-working.gif" title="It's working!!!" />

Forgive us for the prequel meme. Still - we've gotten a lot working under the hood! You now have:

-   A working Google Photos alternative
-   A way to forward internet traffic to your device
-   A platform for hosting websites and apps from home

More technically:

-   A valid SSL certificate for your built-in `k8g8.com` addresses
-   Automatic dynamic DNS via built-in `ksdns.io`
-   A full Kubernetes cluster

If you've made it this far, we'd love it if you'd join our [community chat on Discord](https://discord.gg/N3zNdp7jHc). If discord isn't your style, your feedback would still be greatly appreciated at support@kubesail.com.

We're a small startup with big plans. Hosting your own photos or recipes or blogs is a small but meaningful step towards repairing the way the internet operates, and we're truly thankful that you've joined us on this journey!
