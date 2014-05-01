#/bin/sh

MOODLE_ROOT=/var/www
MOODLE_PATH=${MOODLE_ROOT}/moodle
MOODLE_DATA_DIR=/opt/moodledata
MOODLE_WEBROOT="http://moodle.example.com/moodle"

if [ ! -f /var/log/moodlesetup ];
then
  apt-get update
  
  #Install apache, PHP and mySQL
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password pass'
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password pass'
  apt-get install apache2 libapache2-mod-php5 mysql-server libapache2-mod-auth-mysql php5-mysql php5-gd php5-curl -y
  a2enmod php5i
  
  #download moodle
  if [ ! -f /vagrant/moodle.tgz ]; then
    wget -O /vagrant/moodle.tgz http://softlayer-dal.dl.sourceforge.net/project/moodle/Moodle/stable26/moodle-latest-26.tgz
  fi
  tar -zxvf /vagrant/moodle.tgz -C $MOODLE_ROOT

  #configure moodle
  chown -R root $MOODLE_PATH
  chmod -R 0755 $MOODLE_PATH
  find $MOODLE_PATH -type f -exec chmod 0644 {} \;

  mkdir $MOODLE_DATA_DIR
  chmod 777 $MOODLE_DATA_DIR

  #create database for moodle 
  mysql -u root -ppass -e 'create database moodle'
  
  #install moodle
  php ${MOODLE_PATH}/admin/cli/install.php --non-interactive --wwwroot="${MOODLE_WEBROOT}" --dataroot=${MOODLE_DATA_DIR} --dbpass=pass --fullname="Moodle LTI setup" --shortname="Moodle LTI" --adminpass="pass" --agree-license
  chown -R www-data.www-data ${MOODLE_PATH}
  
  mysql -u root -ppass -e "use moodle; UPDATE mdl_user SET email='admin@example.com' WHERE username='admin'"
  touch /var/log/moodlesetup 
else
  if [ ! -e "/var/run/apache2" ]; then
    mkdir /var/run/apache2
  fi
fi

/etc/init.d/apache2 restart
#show IP address
ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print "IP ADDRESS: "$1}'
