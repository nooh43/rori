#!/bin/bash
# Ruby On Rails initializer - RORi
# Version : V 0.4.5
# Author  : Nasser Alhumood
# .-.    . . .-.-.
# |.|.-.-|-.-|-`-..-,.-.. .
# `-``-`-'-' ' `-'`'-'   `

# Some Unnecessary Variables, but they're here anyway
version=V0.4.5
oss="CentOs7, RHEL7"
test 
# Clear
clear

# Welcome Massage
echo +=================================
echo +" "Ruby On Rails initializer $version
echo +" "supported operating systems: $oss
echo +=================================
echo
echo

# Making sure you wanna continue
read -p "would you like to continue ? [y/N] "
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo No problem, goodbye!
  exit 0
fi

# Step 1 : Updating the systems
sudo yum -y update
# Step 2 : installing epel
sudo yum -y install yum install epel-release
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y update
# Step 3 : Prepare the system and install dependencies
sudo yum install -y curl gpg gcc gcc-c++ make
# Step 4 : install rvm
sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | sudo bash -s stable
sudo usermod -a -G rvm `whoami`
if sudo grep -q secure_path /etc/sudoers; then sudo sh -c "echo export rvmsudo_secure_path=1 >> /etc/profile.d/rvm_secure_path.sh" && echo Environment variable installed; fi
# Step 5 : ask to logout and login again to continue

# Step 6 : installing ruby
rvm install ruby
rvm --default use ruby
gem install bundler --no-rdoc --no-ri

# Step 7 : install node js and npm
sudo yum install -y --enablerepo=epel nodejs npm

# Step 8 : prepare for Passenger installation
sudo yum install -y epel-release yum-utils
sudo yum-config-manager --enable epel
sudo yum clean all && sudo yum update -y
sudo yum install -y ntp
sudo chkconfig ntpd on
sudo ntpdate pool.ntp.org
sudo service ntpd start

# Step 9 : install Passenger and apache
sudo yum install -y pygpgme curl
sudo curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo
sudo yum install -y mod_passenger || sudo yum-config-manager --enable cr && sudo yum install -y mod_passenger
sudo systemctl restart httpd
sudo yum update

# Step 10: install git
sudo yum install -y git

# Step 11: setting up the directory
sudo mkdir -p /var/www/`whoami`
sudo chown `whoami`: /var/www/`whoami`
sudo cd /var/www/`whoami`
rvm use `ruby -v`
gem install rails
