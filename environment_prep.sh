#!/bin/bash
set -x
sudo yum -y install ntp
sudo systemctl enable ntpd
sudo systemctl disable firewalld
sudo service firewalld stop
sudo setenforce 0
sudo umask 0022
