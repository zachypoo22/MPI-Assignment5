#!/bin/bash

set -x
sudo yum -y group install "Development Tools"
sudo touch /ISITDONE.log
sudo wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.gz
sudo tar xzf openmpi-3.1.2.tar.gz
cd openmpi-3.1.2
sudo ./configure --prefix=/software/openmpi/3.1.2
sudo echo "MPI: done configuring" >> /ISITDONE.log
sudo make
sudo echo "MPI: done making" >> /ISITDONE.log
sudo make all install
sudo echo "MPI: done make all install" >> /ISITDONE.log
cd ..
sudo rm -Rf openmpi-3.1.2
sudo rm -Rf openmpi-3.1.2.tar.gz
sudo echo "export PATH='$PATH:/software/openmpi/3.1.2/bin'" >> /users/ab899511/.bashrc
sudo echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/software/openmpi/3.1.2/lib/'" >> /users/ab899511/.bashrc
source ~/.bashrc
sudo echo "all done" >> /ISITDONE.log
