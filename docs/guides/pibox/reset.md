# Factory Reset

## Reset containerd

Ocassionally, k3s can get into a state where it is not in sync with the underlying container system (containerd). This is the first and least obtrusive debugging step.

    for i in $(sudo k3s ctr c ls | awk '{print $1}'); do sudo k3s ctr c rm $i; done
    sudo service k3s restart

## Reset Kubernetes (most common)

You can use these commands to reset your Kubernetes (K3s) installation to the factory defaults:

```bash
/usr/local/bin/k3s-uninstall.sh
curl --connect-timeout 10 --retry 5 --retry-delay 3 -L https://get.k3s.io | INSTALL_K3S_CHANNEL=stable INSTALL_K3S_EXEC="server --cluster-cidr=172.30.0.0/16 --service-cidr=172.31.0.0/16 --disable=traefik --kubelet-arg container-log-max-files=3 --kubelet-arg container-log-max-size=10Mi --disable-network-policy" sh
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
