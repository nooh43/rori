#!/bin/bash
# Ruby On Rails initializer - RORi
# Version : V 0.5.0
# Author  : Nasser Alhumood
# .-.    . . .-.-.
# |.|.-.-|-.-|-`-..-,.-.. .
# `-``-`-'-' ' `-'`'-'   `

# Some Unnecessary Variables, but they're here anyway
version=V0.5.0
oss="CentOs7, RHEL7"
dir=/etc/profile.d/rvm_secure_path.sh

# Clear
clear

# Welcome Massage
echo +=================================
echo +" "Ruby On Rails initializer $version
echo +" "supported operating systems: $oss
echo +=================================
echo
echo

# making sure user loginout and in again
if [ ! -d "$dir" ];
then
  # Making sure you wanna continue
  read -p "would you like to continue ? [y/N] "
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo No problem, goodbye!
    exit 0
  fi

  # Step 1 : Updating the systems
  echo "SYSTEM UPDATE               [in progress]"
  sudo yum -y update &>/dev/null
  echo "SYSTEM UPDATE               [   +done   ]"
  # Step 2 : installing epel
  echo "EPEL INSTALLATION           [in progress]"
  sudo yum -y install yum install epel-release &>/dev/null
  sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &>/dev/null
  sudo yum -y update &>/dev/null
  echo "EPEL INSTALLATION           [   +done   ]"
  # Step 3 : Prepare the system and install dependencies
  echo "INSTALL DEPENDENCIES        [in progress]"
  sudo yum install -y curl gpg gcc gcc-c++ make &>/dev/null
  echo "INSTALL DEPENDENCIES        [   +done   ]"
  # Step 4 : install rvm
  echo "INSTALL RVM                 [in progress]"
  sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 &>/dev/null
  curl -sSL https://get.rvm.io | sudo bash -s stable &>/dev/null
  sudo usermod -a -G rvm `whoami` &>/dev/null
  if sudo grep -q secure_path /etc/sudoers; then sudo sh -c "echo export rvmsudo_secure_path=1 >> /etc/profile.d/rvm_secure_path.sh" && echo Environment variable installed; fi &>/dev/null
  echo "INSTALL RVM                 [   +done   ]"
  # Step 5 : ask to logout and login again to continue
  echo "Awesome we are half way through it, now you have to logout from the terminal then login again"
  exit 0
fi

echo "Cool you are in step two now!"

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
