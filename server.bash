#!/bin/bash

# set a default environment to 'devalopment'
ENV="development"

if [ "$#" -gt 0 ]; then
  ENV=$1
fi

echo "==========================================================================="
echo "                    Setting up environment for $ENV                        "
echo "==========================================================================="

PROJECT_NAME="cdc-zero-reporting-system"
PROJECT_PATH="/home/$(whoami)/$PROJECT_NAME"
DB_NAME='cdc_call_development'

MYSQL_ROOT_PWD="123456"
DB_USER='zeroreporting'
DB_USER_PWD='123456'
HOST_ALLOWED='localhost'

# Set up project path & database
if [ $ENV = "production" -o $ENV = "Production" -o $ENV = "PRODUCTION" ]; then
  DB_NAME='cdc_call_production'
  PROJECT_PATH="/var/www/$PROJECT_NAME"
fi

sudo apt-get update -y
sudo apt-get install -y mercurial git curl htop openssl

# dependencies for Ruby
sudo apt-get install -y git-core git curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
libxml2 libxml2-dev libyaml-dev libxslt1-dev libcurl4-openssl-dev python-all-dev git python-dev python-pip python-software-properties g++ gcc \
libreadline6-dev nodejs

# Install rbenv and Ruby
if [ ! -d ~/.rbenv ]; then
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  cd ~/.rbenv && src/configure && make -C src
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

  # Install ruby-build rbenv plugin
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

  # Reload rbenv environment
  source ~/.bash_profile

  # Install Ruby
  rbenv install 2.1.2
fi

# Install database MySQL
if ! which mysql > /dev/null; then
  # Tell MySQL to do not prompt password
  export DEBIAN_FRONTEND="noninteractive"

  sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PWD"
  sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PWD"

  # Database
  sudo apt-get update -y
  sudo apt-get install -y mysql-server libmysqlclient-dev
fi

# Setting up Database
mysql -uroot -p$MYSQL_ROOT_PWD -e "create database IF NOT EXISTS $DB_NAME DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
# you must to drop user if exists cuz mysql v5.5 doesn't have command if [not] exists
mysql -uroot -p$MYSQL_ROOT_PWD -e "create user $DB_USER@$HOST_ALLOWED IDENTIFIED BY '$DB_USER_PWD';"
mysql -uroot -p$MYSQL_ROOT_PWD -e "grant all on $DB_NAME.* to $DB_USER@$HOST_ALLOWED;"

# GET CURRENT PROJECT PATH
if [ ! -d /var/www/ ]; then
  sudo mkdir /var/www/

  # Allow write permission on /var/www to other
  sudo chmod o+w /var/www/
fi

if [ -d $PROJECT_PATH ];then
  rm -fr $PROJECT_PATH
fi

git clone -b develop https://kakada@bitbucket.org/ilab/cdc-zero-reporting-system.git $PROJECT_PATH
cd $PROJECT_PATH

# Ignore gem rdoc and ri
echo 'gem: --no-ri --no-rdoc' > ~/.gemrc
gem install bundler --no-ri --no-rdoc

if [ $ENV = "production" -o $ENV = "Production" -o $ENV = "PRODUCTION" ]; then
  bundle install --without development test
else
  bundle install
fi

# Setting up web server(Apache)
if [ $ENV = "production" -o $ENV = "Production" -o $ENV = "PRODUCTION" ]; then
  # Install apache web server
  sudo apt-get install -y apache2

  sudo apt-get install -y libcurl4-openssl-dev apache2-mpm-worker apache2-threaded-dev libapr1-dev libaprutil1-dev

  # Install passenger
  cd $PROJECT_PATH

  gem install passenger --no-ri --no-rdoc

  PASSENGER_MODULE_PATH=/etc/apache2/mods-available/passenger.load
  if [ ! -f $PASSENGER_MODULE_PATH ]; then
    passenger-install-apache2-module -a
    passenger-install-apache2-module --snippet | sudo tee -a $PASSENGER_MODULE_PATH
  fi

  # Enable passenger module in Apache2
  sudo a2enmod passenger

  # VirtualHost
  sudo echo -e "<VirtualHost *:80>
    DocumentRoot $PROJECT_PATH/public
    PassengerSpawnMethod conservative
</VirtualHost>" | sudo tee /etc/apache2/sites-available/000-default.conf

  # Enable site
  sudo a2ensite 000-default.conf

  # Restart apache2
  sudo service apache2 restart

fi
