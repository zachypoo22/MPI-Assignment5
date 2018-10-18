## mount /software
sudo service portmap start
sudo mkdir /software
sudo mount -t nfs head:/software /software


## mount /scratch
#sudo service portmap start
sudo mkdir /scratch
sudo mount -t nfs storage:/scratch /scratch

## Modify PATH
sudo echo "export PATH='$PATH:/software/openmpi/3.1.2/bin'" >> /users/zm875176/.bashrc
sudo echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/software/openmpi/3.1.2/lib/'" >> /users/zm875176/.bashrc
source ~/.bashrc
