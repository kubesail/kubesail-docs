# Factory Reset

## Reset Kubernetes (most common)

You can use these commands to reset your Kubernetes (K3s) installation to the factory defaults:

```bash
/usr/local/bin/k3s-uninstall.sh
curl -L https://get.k3s.io | INSTALL_K3S_CHANNEL=stable INSTALL_K3S_EXEC="server --cluster-cidr=172.31.10.0/24 --service-cidr=172.31.11.0/24 --no-deploy traefik --disable=traefik --kubelet-arg container-log-max-files=3 --kubelet-arg container-log-max-size=10Mi --disable-network-policy" sh
sudo kubectl create -f https://api.kubesail.com/byoc
```

Then scan the QR code on the screen to set up your PiBox as if it were new.

## Full reflash

This method is rarely needed and involves opening your hardware to reflash the Pi's onboard flash. However, if you want to fully reset your PiBox, you can follow the instructions on the [rpiboot](/guides/pibox/rpiboot/) page.

<hr/>

You may want to first remove your disks from the LVM so your PiBox can format them the next time it boots:

<!-- prettier-ignore -->
!!! warning
    These commands will delete ALL data on your disks! Proceed with caution!

```bash
service k3s stop
killall containerd-shim
umount /var/lib/rancher
umount /var/lib/rancher-ssd
wipefs -af /dev/pibox-group/k3s
lvremove /dev/pibox-group/k3s
vgreduce --removemissing pibox-group
vgremove pibox-group
pvremove /dev/sda1
pvremove /dev/sdb1
wipefs -a /dev/sda1
wipefs -a /dev/sdb1
sfdisk --delete /dev/sda 1
sfdisk --delete /dev/sdb 1
wipefs -a /dev/sda
wipefs -a /dev/sdb
```
