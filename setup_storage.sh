## Add /scratch
sudo chkconfig --level 35 nfs on
sudo mkdir scratch
sudo chmod 777 /etc/exports
i="1"
while [ $i -le 3 ]
do
sudo echo "/scratch compute-$i(rw,sync,no_root_squash)" >> /etc/exports
((i++))
done
sudo service nfs start

## Modify path
sudo echo "export PATH='$PATH:/software/openmpi/3.1.2/bin'" >> /users/zm875176/.bashrc
sudo echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/software/openmpi/3.1.2/lib/'" >> /users/zm875176/.bashrc
source ~/.bashrc

## copy files for part 1
cp /local/repository/source/* /scratch
