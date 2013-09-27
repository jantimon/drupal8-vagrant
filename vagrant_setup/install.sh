# Create empty database
mysql -uroot -psecret -e "DROP DATABASE IF EXISTS drupal;"
mysql -uroot -psecret -e "CREATE DATABASE drupal;"

if [ ! -d "/var/www/htdocs/modules" ]; then
  # remove any existing files - if they exist
  if [ -d "/var/www/htdocs" ]; then
    rm -rf /var/www/htdocs/
  fi

  # clone the latest drupal 8 branch
  git clone --branch 8.x http://git.drupal.org/project/drupal.git /var/www/htdocs/
  cd /var/www/htdocs/

else
  # there is a drupal 8 repository already
  # only pull the latest changes
  cd /var/www/htdocs/
  git pull
fi

drush si --account-name=vagrant --account-pass=secret --site-name=drupal-8-sandbox --db-url=mysql://root:secret@localhost/drupal -y