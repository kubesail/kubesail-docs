# Install KubeSail

KubeSail helps you manage software on your PiBox, or any other computer running Kubernetes. If you don't yet have a KubeSail account, creating one is as easy as [signing up with GitHub](https://kubesail.com/). Once you've done that, install the setup script:

```bash
curl -s https://raw.githubusercontent.com/kubesail/pibox-os/main/setup.sh | sudo bash
```

Then run

```bash
sudo kubesail
```

to set up KubeSail and install your SSH keys.

After a few minutes, your PiBox will appear in the [clusters](https://kubesail.com/clusters) tab of the KubeSail dashboard.
