#!/bin/bash
sudo mkdir /test1

set -x
sudo yum -y group install "Development Tools"
sudo mkdir /test2

sudo wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.2.tar.gz
sudo tar xzf openmpi-3.1.2.tar.gz
cd openmpi-3.1.2
sudo ./configure --prefix=/software/openmpi/3.1.2
sudo mkdir /test3

sudo make
sudo mkdir /test4

sudo make all install
sudo mkdir /test5

cd ..
sudo rm -Rf openmpi-3.1.2
sudo rm -Rf openmpi-3.1.2.tar.gz
sudo echo "export PATH='$PATH:/software/openmpi/3.1.2/bin'" >> /users/zm875176/.bashrc
sudo echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/software/openmpi/3.1.2/lib/'" >> /users/zm875176/.bashrc
source ~/.bashrc
