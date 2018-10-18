## Add /software
sudo chkconfig --level 35 nfs on
sudo mkdir software
i="1"
sudo chmod 777 /etc/exports
while [ $i -le 12 ]
do
sudo echo "/software compute-$i(rw,sync,no_root_squash)" >> /etc/exports
((i++))
done
sudo service nfs start

## Mount /scratch
sudo service portmap start
sudo mkdir /scratch
sudo mount -t nfs storage:/scratch /scratch
