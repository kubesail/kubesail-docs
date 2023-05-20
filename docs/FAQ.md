## KubeSail, the Company

### What is self hosting?

Self-Hosting means running server software yourself, on computers you own. Although every day billions of people use web browsers, the client side of the internet, almost all the servers they connect to are owned by a handful of the largest software companies in the world. For example, to visit Sarah's page, you don't visit Sarah's computer - you visit Google's or Facebook's.

Self-Hosting fixes the internet by putting server-software and skills into the hands of everyone. Own your data, cut the expensive hosted subscription services, learn real skills: That's what self-hosting does!

### What operating systems does KubeSail support?

KubeSail should work with any Linux operating system that can run a modern version of Kubernetes. We test using Debian 11 and Ubuntu 20.04, and we use Debian 11 for the PiBox's base operating system. You can even run KubeSail on Windows or Mac via Docker-Desktop or Rancher-Desktop, although we can't promise it will work properly. If you're running into issues using KubeSail with any Kubernetes cluster, feel free to join us in chat and we'll figure it out!

### What happens to my server if KubeSail goes away?

We've actually had this situation in mind since day one. Your server and your data belongs to _you_, and the only things that would stop working if KubeSail suddenly ceased to exist are:

-   KubeSail.com control panel
-   Remote tunneling (k8g8.com and ksdns.io addresses)
-   Automatic backups

Your apps would continue to run and your data would remain on your devices. Each of the services we bundle can be replicated by a handful of other services (for example, we would recommend CloudFlare's tunneling product and BackBlaze's backup product), and we'll work hard to provide guides and tutorials for migration.

### Does KubeSail still provide enterprise DevOps training?

Yes, although on a limited basis. We've pivoted to focus on our self-hosting product, but are still available for select trainings. Please see https://kubesail.com/training for more information.

### Why do you use Discord if you're supposed to be a self-hosting company?

We're not [zealots](https://static.wikia.nocookie.net/starcraft/images/f/f3/Zealot_SC2_Cncpt1.jpg) - hosted platforms do have a lot of utility! One of our core values is "**Pragmatism over idealism**", and that certainly applies here.

While we do plan on migrating to Mastodon one day, we've yet to make that jump. Bear with us for our imperfections.

### Company Values

-   🦾 **Integrity**: Don't be Evil.
-   👐 **Openness**: Share everything, with everyone, as much as is reasonable.
-   💟 **Friendliness**: Make people happier with code, hardware, and attitudes.
-   🏗️ **Endurance**: Build products to last; stay healthy and happy. It's a marathon, not a sprint.

## PiBox, the Product

### Is it plug and play?

The model with SSDs pre-installed is plug and play. Otherwise adding a hard drive is a fairly easy step. Our software will setup new drives automatically after you plug them in.

### Can I access my PiBox on the internet from anywhere?

Yes you can access it anywhere! Our tunneling software keeps your data encrypted all the way to your PiBox, so you can access your apps securely wherever you are. You can also use Kubesail to easily add passwords to apps that don’t have any built in security.

### Are the apps (Photoprism, NextCloud, etc...) automatically updated?

Software updates are as simple as installing a new app. Just a single click from our App Store. We don’t currently auto update since there may be breaking changes between versions of apps you may want to know about.

### Does my IP address have to be static for me to access it from the internet?

Your IP does not have to be static. However, if you do want more security, allowing only specific IPs to access your apps is an included feature and is easy to set up. You can securely control which IPs can access your server from anywhere via the KubeSail dashboard.

### What are the available apps that I can install on the box?

We have an App Store that anyone can publish to at https://kubesail.com/templates. We also maintain a number of “official” templates that are known to work well on the PiBox.

### Are there native back up solution to cloud storage like S3 or backblaze?

One of the major features of our “Standard” plan is that it includes backups to a cloud provider like AWS or BackBlaze. We make it seamless to take backups; your data is first encrypted on your device and then backed up to our cloud servers. This means we can never gain access to your personal data.

### Electricity cost is annoying in the EU now, how much is the power consumption of PiBox per month with 2 drives?

Max power even under load with 2 drives is 15W, and normally half that while idle. We designed this to be always on and super efficient!

### How do I check the agent logs if something isn't working?

On your system, you can checkout the `kubesail-agent` namespace which contains the agent. You can view the logs with: `sudo kubectl -n kubesail-agent logs -l app=kubesail-agent`. You might also try running `curl -sL https://pibox.io/help.sh | sudo bash` to submit a help request.

### How do I find where my "KubeSail Apps" store data on my pibox?

All KubeSail apps are really Kubernetes apps, an open source tool for which there is a lot of documentation available! We use "k3s", which stores all of its data at `/var/lib/rancher/k3s/storage`. In that directory, you'll find directories that end with titles like "default_deluge-config" - which means a disk in the "default" namespace named "deluge-config". K3s can also be configured to use any other type of disk, but we use simple directories at `/var/lib/rancher/k3s/storage` by default.

### What do I do if my certificate isn't working?

First, check that there aren't any updates available at https://kubesail.com/clusters. If not, you can try restarting the agent with: `sudo kubectl -n kubesail-agent delete pods --all`, which should reverify your local certificates.

### How do I get the PiBox screen working?

See the [PiBox docs](https://docs.kubesail.com/guides/pibox/kubesail/). If you're more advanced, you can view all of our "Pibox OS" scripts at https://github.com/kubesail/pibox-os/

### My ".local." domains are not working, please help!

Some ISPs, namely Comcast/XFinity, block our "local.k8g8.com" domains because they're public DNS names that point at private IP addresses. For more reasons than just to make our domains work, we highly suggest you do not use these DNS providers! Change your workstation or (even better) your Routers DNS configuration to use [CloudFlare's DNS (1.1.1.1)](https://www.cloudflare.com/dns/) or [Google's DNS (8.8.8.8)](https://developers.google.com/speed/public-dns). This will both fix our domains, as well as speed up your browsing and increase your privacy.
