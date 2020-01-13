# df -H
# lsblk
# sudo file -s /dev/xvdf
sudo mkfs -t xfs /dev/xvdf
sudo file -s /dev/xvdf
sudo mkdir -p /cloudgenius
sudo mount /dev/xvdf /cloudgenius
sudo cp /etc/fstab /etc/fstab.orig
sudo tee -a /etc/fstab > /dev/null << EOF
UUID=$(lsblk -o +UUID /dev/xvdf -o UUID |grep -v UUID)  /cloudgenius  xfs  defaults,nofail  0  2
EOF
sudo umount /cloudgenius
sudo mount -a
ls -la /cloudgenius
sudo chown -R ubuntu:ubuntu /cloudgenius
ln -s /cloudgenius ~/cloudgenius
