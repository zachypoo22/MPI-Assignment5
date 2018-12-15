#! /bin/bash

sudo yum install mariadb-server mariadb-devel -y
yum groupinstall 'Development Tools' -y

export MUNGEUSER=981
sudo groupadd -g $MUNGEUSER munge
useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SlurmUSER=982
groupadd -g $SlurmUSER slurm
useradd  -m -c "Slurm workload manager" -d /var/lib/slurm -u $SlurmUSER -g slurm  -s /bin/bash slurm


# munge key goes here
sudo yum install munge munge-libs munge-devel -y

sudo /usr/sbin/create-munge-key
sudo cp /etc/munge/munge.key /scratch
sudo chown -R munge: /etc/munge/ var/log/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/

sudo systemctl enable munge
sudo systemctl start munge

sudo wget https://download.schedmd.com/slurm/slurm-18.08.3.tar.bz2

sudo tar xvjf slurm-18.08.3.tar.bz2
cd slurm-18.08.3

#add status log
sudo ./configure
sudo echo "SLURM: done configuring" >> /ISITDONE.log
sudo make
sudo echo "SLURM: done making" >> /ISITDONE.log
sudo make install
sudo echo "SLURM: done make all install" >> /ISITDONE.log

#copy slurm.conf PUT SLURM INTO SOURCE FOLDER
sudo cp /local/repository/source/slurm.conf /usr/local/etc/slurm.conf

sudo mkdir /var/spool/slurmctld
sudo chown slurm: /var/spool/slurmctld
sudo chmod 755 /var/spool/slurmctld
sudo touch /var/log/slurmctld.log
sudo chown slurm: /var/log/slurmctld.log
sudo touch /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log
sudo chown slurm: /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log
sudo mkdir /var/spool/slurmd
sudo chown slurm: /var/spool/slurmd
sudo chmod 755 /var/spool/slurmd
sudo touch /var/log/slurmd.log
sudo chown slurm: /var/log/slurmd.log

sudo sudo systemctl stop firewalld
systemctl disable firewalld

sudo yum install ntp -y
sudo chkconfig ntpd on
sudo ntpdate pool.ntp.org
sudo systemctl start ntpd
