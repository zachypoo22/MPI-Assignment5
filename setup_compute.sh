## mount /software
sudo service portmap start
sudo mkdir /mnt/software
sudo mount -t nfs head:/software /mnt/software


## mount /scratch
#sudo service portmap start
sudo mkdir /mnt/scratch
sudo mount -t nfs storage:/scratch /mnt/scratch

## Modify PATH
sudo echo "export PATH='$PATH:/mnt/software/openmpi/3.1.2/bin'" >> /users/zm875176/.bashrc
sudo echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/mnt/software/openmpi/3.1.2/lib/'" >> /users/zm875176/.bashrc
source ~/.bashrc
