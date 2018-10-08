## Add /scratch
sudo chkconfig --level 35 nfs on
sudo mkdir scratch
sudo chmod 777 /etc/exports
while [ $i -le 3 ]
do
sudo echo "/scratch compute-$i(rw,sync,no_root_squash)" >> /etc/exports
((i++))
done
sudo service nfs start
