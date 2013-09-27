# Update home directory:
usermod -d /var/www/ vagrant

apt-get -y update

# build helper
apt-get install -y curl build-essential git-core

# apache
apt-get install -y apache2

# vim
apt-get intall -y vim

# mysql
if [ -z `which mysql` ]; then
  DEBIAN_FRONTEND=noninteractive  apt-get install -y mysql-server
  apt-get install -y mysql-client
  mysqladmin -u root password secret
fi

# PHP
apt-get install -y php5 php5-gd php5-curl php5-mcrypt php5-xdebug php5-mysql

# Drush
if [ -z `which drush` ]; then
  git clone https://github.com/drush-ops/drush.git /usr/share/drush/drush-core
  chmod u+x /usr/share/drush/drush-core
  ln -s /usr/share/drush/drush-core/drush /usr/bin/drush
  export PATH="$PATH: /usr/share/drush/drush-core:/usr/local/bin"
  source .bashrc
  cp /usr/share/drush/drush-core/drush.complete.sh /etc/bash_completion.d/
  sudo -u vagrant drush help
  chown -R vagrant:vagrant /home/vagrant/.drush/
fi

# Link /var/www
if [ ! -d "/var/www/private" ]; then
  rm -rf /var/www/
  ln -s /vagrant /var/www
  mkdir -p /var/www/private
  chown -R www-data:www-data /var/www
fi

# Sync configuration files
rsync --keep-dirlinks -recursive --perms --owner --group /vagrant/vagrant_setup/root/ /

# Use the gateway (host) as xdebug host
route -n | grep 'UG    0' | awk '{print "\nxdebug.remote_host = " $2}' >> /etc/php5/conf.d/xdebug.ini

# Remove the default apache site
a2dissite default

# Add the htdocs folder
a2ensite vagrant

a2enmod rewrite

# Install pecl
if [ -z `which pecl` ]; then
  apt-get install -y  php-pear
fi

pecl install uploadprogress

# install .so extensions
find /usr/lib/php5/ | grep xdebug.so | awk '{print "\nzend_extension = " $1 "\n"}' >> /etc/php5/conf.d/xdebug.ini
find /usr/lib/php5/ | grep uploadprogress.so | awk '{print "\nextension = " $1}' >> /etc/php5/apache2/php.ini

a2enmod uploadprogress

# Restart apache
/etc/init.d/apache2 restart

# Install current drupal on the first run
if [ ! -f "/var/www/htdocs/index.php" ]; then
  sh /vagrant/vagrant_setup/install.sh
fi

# Link reinstall script:
if [ ! -f "/home/vagrant/reinstall.sh" ]; then
  sudo -u vagrant ln -s /vagrant/vagrant_setup/install.sh /home/vagrant/reinstall.sh
fi

echo "Installation complete user name: vagrant password: secret"
