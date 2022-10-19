# Install KubeSail

KubeSail helps you manage software on your PiBox, or any other computer running Kubernetes. If you don't yet have a KubeSail account, creating one is as easy as [signing up with GitHub](https://kubesail.com/). Once you've done that, install the setup script:

```bash
curl -s https://raw.githubusercontent.com/kubesail/pibox-os/main/setup.sh | sudo bash
```

Then scan the QR code on the screen or checkout the kubesail-agent logs for the verification link! If checking the PiBox screen isn't easy, you can use:

```
sudo kubectl -n kubesail-agent logs -l app=kubesail-agent
```
to look for the verification link as well.
