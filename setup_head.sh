## Add /software
sudo chkconfig --level 35 nfs on
sudo mkdir software
sudo echo "/software compute-1(rw,sync,no_root_squash)" >> /etc/exports
sudo service nfs start

## Mount /scratch
sudo service portmap start
sudo mkdir /mnt/scratch
sudo mount -t nfs storage:/scratch /mnt/scratch
