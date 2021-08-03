# df -H
# lsblk
# sudo file -s /dev/nvme1n1
sudo mkfs -t xfs /dev/nvme1n1
sudo file -s /dev/nvme1n1
sudo mkdir -p /cloudgenius
sudo mount /dev/nvme1n1 /cloudgenius
sudo cp /etc/fstab /etc/fstab.orig
sudo tee -a /etc/fstab > /dev/null << EOF
UUID=$(lsblk -o +UUID /dev/nvme1n1 -o UUID |grep -v UUID)  /cloudgenius  xfs  defaults,nofail  0  2
EOF
sudo umount /cloudgenius
sudo mount -a
ls -la /cloudgenius
sudo chown -R ubuntu:ubuntu /cloudgenius
ln -s /cloudgenius ~/cloudgenius
