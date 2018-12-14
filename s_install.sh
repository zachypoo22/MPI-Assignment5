#! /bin/bash

yum install mariadb-server mariadb-devel -y
yum groupinstall 'Development Tools' -y

export MUNGEUSER=981
groupadd -g $MUNGEUSER munge
useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SlurmUSER=982
groupadd -g $SlurmUSER slurm
useradd  -m -c "Slurm workload manager" -d /var/lib/slurm -u $SlurmUSER -g slurm  -s /bin/bash slurm


# munge key goes here





systemctl enable munge
systemctl start munge

wget https://download.schedmd.com/slurm/slurm-18.08.3.tar.bz2

tar xvjf slurm-18.08.3.tar.bz2
cd slurm-18.08.3

./configure
make
make install

cp /local/repository/slurm/slurm.conf /usr/local/etc/slurm.conf

mkdir /var/spool/slurmctld
chown slurm: /var/spool/slurmctld
chmod 755 /var/spool/slurmctld
touch /var/log/slurmctld.log
chown slurm: /var/log/slurmctld.log
touch /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log
chown slurm: /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log
mkdir /var/spool/slurmd
chown slurm: /var/spool/slurmd
chmod 755 /var/spool/slurmd
touch /var/log/slurmd.log
chown slurm: /var/log/slurmd.log

systemctl stop firewalld
systemctl disable firewalld

yum install ntp -y
chkconfig ntpd on
ntpdate pool.ntp.org
systemctl start ntpd
