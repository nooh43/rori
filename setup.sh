#!/bin/bash
# Ruby On Rails initializer - RORi
# Version : V 0.8.0
# Author  : Nasser Alhumood
# .-.    . . .-.-.
# |.|.-.-|-.-|-`-..-,.-.. .
# `-``-`-'-' ' `-'`'-'   `

# Some Unnecessary Variables, but they're here anyway
version=V0.8.0
oss="CentOs7, RHEL7"
file=/etc/profile.d/rvm_secure_path.sh

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
if [ -e "$file" ];
then
  echo "Cool you are in step two now!"

  # Step 6 : installing ruby
  echo "INSTALL RUBY                [in progress]"
  {
    rvm install ruby
    rvm --default use ruby
    gem install bundler --no-rdoc --no-ri
  } > out.log 2> err.log
  echo "INSTALL RUBY                [   +done   ]"

  # Step 7 : install node js and npm
  echo "INSTALL NODE JS             [in progress]"
  {
    sudo yum install -y --enablerepo=epel nodejs npm
  } > out.log 2> err.log
  echo "INSTALL NODE JS             [   +done   ]"

  # Step 8 : prepare for Passenger installation
  echo "PRE-PASSENGER INSTALLATION  [in progress]"
  {
    sudo yum install -y epel-release yum-utils
    sudo yum-config-manager --enable epel
    sudo yum clean all && sudo yum update -y
    sudo yum install -y ntp
    sudo chkconfig ntpd on
    sudo ntpdate pool.ntp.org
    sudo service ntpd start
  } > out.log 2> err.log
  echo "PRE-PASSENGER INSTALLATION  [   +done   ]"

  # Step 9 : install Passenger and apache
  echo "INSTALL PASSENGER & APACHE  [in progress]"
  {
    sudo yum install -y pygpgme curl
    sudo curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo
    sudo yum install -y mod_passenger || sudo yum-config-manager --enable cr && sudo yum install -y mod_passenger
    sudo systemctl restart httpd
    sudo yum update
  } > out.log 2> err.log
  echo "INSTALL PASSENGER & APACHE  [   +done   ]"

  # Step 10: install git
  echo "INSTALL GIT                 [in progress]"
  {
    sudo yum install -y git
  } > out.log 2> err.log
  echo "INSTALL GIT                 [   +done   ]"

  # Step 11: setting up the directory
  echo "DIRECTORY SETTING           [in progress]"
  {
    sudo mkdir -p /var/www/`whoami`
    sudo chown `whoami`: /var/www/`whoami`
    sudo cd /var/www/`whoami`
    rvm use ruby
    gem install rails
  } > out.log 2> err.log
  echo "DIRECTORY SETTING           [   +done   ]"

  # Thank you message
  echo
  echo
  echo "Thank you for using this script, ruby on rails should be installed in your system now!"
  exit 0
fi

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
{
  sudo yum -y update
} > out.log 2> err.log
echo "SYSTEM UPDATE               [   +done   ]"

# Step 2 : installing epel
echo "EPEL INSTALLATION           [in progress]"
{
  sudo yum -y install yum install epel-release
  sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  sudo yum -y update
} > out.log 2> err.log
echo "EPEL INSTALLATION           [   +done   ]"

# Step 3 : Prepare the system and install dependencies
echo "INSTALL DEPENDENCIES        [in progress]"
{
  sudo yum install -y curl gpg gcc gcc-c++ make
} > out.log 2> err.log
echo "INSTALL DEPENDENCIES        [   +done   ]"

# Step 4 : install rvm
echo "INSTALL RVM                 [in progress]"
{
  sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -sSL https://get.rvm.io | sudo bash -s stable
  sudo usermod -a -G rvm `whoami`
  if sudo grep -q secure_path /etc/sudoers; then sudo sh -c "echo export rvmsudo_secure_path=1 >> /etc/profile.d/rvm_secure_path.sh" && echo Environment variable installed; fi
} > out.log 2> err.log
echo "INSTALL RVM                 [   +done   ]"

# Step 5 : ask to logout and login again to continue
echo "Awesome we are half way through it, now you have to logout from the terminal then login again"
