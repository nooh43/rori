#!/bin/bash
# Ruby On Rails initializer - RORi
# Version : V 0.9.0
# Author  : Nasser Alhumood
# .-.    . . .-.-.
# |.|.-.-|-.-|-`-..-,.-.. .
# `-``-`-'-' ' `-'`'-'   `

# Some Unnecessary Variables, but they're here anyway
version=V0.9.0
oss="CentOs7, RHEL7"
file=/etc/profile.d/rvm_secure_path.sh

# Clear
clear

# Welcome Massage
echo -e "\e[1;34;1m+=================================\e[0m"
echo -e "\e[1;34;1m+\e[0m" "Ruby On Rails initializer -  `$version`"
echo -e "\e[1;34;1m+\e[0m" "supported operating systems: `$oss`"
echo -e "\e[1;34;1m+=================================\e[0m"
echo
echo

# making sure user loginout and in again
if [ -e "$file" ];
then
  echo -e "Cool you are in step \e[31;1mtwo\e[0m now! I have to remind you this could take some time."
  echo "You should be patient if you want to continue..."
  # Making sure you wanna continue
  read -p "would you like to continue ? [y/N] "
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    echo No problem, goodbye!
    exit 0
  fi

  # Step 6 : installing ruby
  echo -e "INSTALL RUBY                [\e[1;30;1;1;47min progress\e[0m]"
  {
    rvm install ruby
    rvm --default use ruby
    gem install bundler --no-rdoc --no-ri
  } > log/out5.log 2> log/err5.log
  echo -e "INSTALL RUBY                [[\e[1;37;1;1;42m   +done   \e[0m]]"

  # Step 7 : install node js and npm
  echo -e "INSTALL NODE JS             [\e[1;30;1;1;47min progress\e[0m]"
  {
    sudo yum install -y --enablerepo=epel nodejs npm
  } > log/out6.log 2> log/err6.log
  echo -e "INSTALL NODE JS             [[\e[1;37;1;1;42m   +done   \e[0m]]"

  # Step 8 : prepare for Passenger installation
  echo -e "PRE-PASSENGER INSTALLATION  [\e[1;30;1;1;47min progress\e[0m]"
  {
    sudo yum install -y epel-release yum-utils
    sudo yum-config-manager --enable epel
    sudo yum clean all && sudo yum update -y
    sudo yum install -y ntp
    sudo chkconfig ntpd on
    sudo ntpdate pool.ntp.org
    sudo service ntpd start
  } > log/out7.log 2> log/err7.log
  echo -e "PRE-PASSENGER INSTALLATION  [[\e[1;37;1;1;42m   +done   \e[0m]]"

  # Step 9 : install Passenger and apache
  echo -e "INSTALL PASSENGER & APACHE  [\e[1;30;1;1;47min progress\e[0m]"
  {
    sudo yum install -y pygpgme curl
    sudo curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo
    sudo yum install -y mod_passenger || sudo yum-config-manager --enable cr && sudo yum install -y mod_passenger
    sudo systemctl restart httpd
    sudo yum update
  } > log/out8.log 2> log/err8.log
  echo -e "INSTALL PASSENGER & APACHE  [[\e[1;37;1;1;42m   +done   \e[0m]]"

  # Step 10: install git
  echo -e "INSTALL GIT                 [\e[1;30;1;1;47min progress\e[0m]"
  {
    sudo yum install -y git
  } > log/out9.log 2> log/err9.log
  echo -e "INSTALL GIT                 [[\e[1;37;1;1;42m   +done   \e[0m]]"

  # Step 11: setting up the directory
  echo -e "DIRECTORY SETTING           [\e[1;30;1;1;47min progress\e[0m]"
  {
    sudo mkdir -p /var/www/`whoami`
    sudo chown `whoami`: /var/www/`whoami`
    sudo cd /var/www/`whoami`
    rvm use ruby
    gem install rails
  } > log/out10.log 2> log/err10.log
  echo -e "DIRECTORY SETTING           [[\e[1;37;1;1;42m   +done   \e[0m]]"

  # Thank you message
  echo
  echo
  echo "Thank you for using this script, ruby on rails should be installed in your system now!"
  exit 0
fi

# Making sure you wanna continue
echo "This script could take some time, don't close the application and wait unil it is completed."
echo "You should be patient if you want to continue..."
read -p "would you like to continue ? [y/N] "
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo No problem, goodbye!
  exit 0
fi

# Step 1 : Updating the systems
echo -e "SYSTEM UPDATE               [\e[1;30;1;1;47min progress\e[0m]"
{
  sudo yum -y update
} > log/out1.log 2> log/err1.log
echo -e "SYSTEM UPDATE               [[\e[1;37;1;1;42m   +done   \e[0m]]"

# Step 2 : installing epel
echo -e "EPEL INSTALLATION           [\e[1;30;1;1;47min progress\e[0m]"
{
  sudo yum -y install yum install epel-release
  sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  sudo yum -y update
} > log/out2.log 2> log/err2.log
echo -e "EPEL INSTALLATION           [[\e[1;37;1;1;42m   +done   \e[0m]]"

# Step 3 : Prepare the system and install dependencies
echo -e "INSTALL DEPENDENCIES        [\e[1;30;1;1;47min progress\e[0m]"
{
  sudo yum install -y curl gpg gcc gcc-c++ make
} > log/out3.log 2> log/err3.log
echo -e "INSTALL DEPENDENCIES        [[\e[1;37;1;1;42m   +done   \e[0m]]"

# Step 4 : install rvm
echo -e "INSTALL RVM                 [\e[1;30;1;1;47min progress\e[0m]"
{
  sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -sSL https://get.rvm.io | sudo bash -s stable
  sudo usermod -a -G rvm `whoami`
  if sudo grep -q secure_path /etc/sudoers; then sudo sh -c "echo export rvmsudo_secure_path=1 >> /etc/profile.d/rvm_secure_path.sh" && echo Environment variable installed; fi
} > log/out4.log 2> log/err4.log
echo -e "INSTALL RVM                 [[\e[1;37;1;1;42m   +done   \e[0m]]"

# Step 5 : ask to logout and login again to continue
echo -e "\e[31;1mAwesome we are half way through it, now you have to logout from the terminal then login again\e[0m"
