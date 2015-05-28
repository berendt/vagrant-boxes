#!/bin/sh

set -x

###################################################################################################
###################################################################################################
# KEYSTONE

cat <<EOT | mysql -u root -pROOT_DB_PASS
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
  IDENTIFIED BY 'KEYSTONE_DBPASS';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
  IDENTIFIED BY 'KEYSTONE_DBPASS';
EOT

yum install -y openstack-keystone python-openstackclient httpd mod_wsgi memcached python-memcached

systemctl enable memcached.service
systemctl start memcached.service

crudini --set /etc/keystone/keystone.conf DEFAULT admin_token RANDOM_TOKEN
crudini --set /etc/keystone/keystone.conf database connection 'mysql://keystone:KEYSTONE_DBPASS@controller/keystone'
crudini --set /etc/keystone/keystone.conf memcache servers 'localhost:11211'
crudini --set /etc/keystone/keystone.conf token provider 'keystone.token.providers.uuid.Provider'
crudini --set /etc/keystone/keystone.conf token driver 'keystone.token.persistence.backends.memcache.Token'
crudini --set /etc/keystone/keystone.conf revoke driver 'keystone.contrib.revoke.backends.sql.Revoke'
crudini --set /etc/keystone/keystone.conf DEFAULT verbose True

keystone-manage pki_setup --keystone-user keystone --keystone-group keystone
chown -R keystone:keystone /var/log/keystone
chown -R keystone:keystone /etc/keystone/ssl
chmod -R o-rwx /etc/keystone/ssl

su -s /bin/sh -c "keystone-manage db_sync" keystone

sed -i -e "s/^#ServerName.*$/ServerName controller/" /etc/httpd/conf/httpd.conf
cat <<EOT >> /etc/httpd/conf.d/wsgi-keystone.conf
Listen 5000
Listen 35357

<VirtualHost *:5000>
    WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
    WSGIProcessGroup keystone-public
    WSGIScriptAlias / /var/www/cgi-bin/keystone/main
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    LogLevel info
    ErrorLogFormat "%{cu}t %M"
    ErrorLog /var/log/httpd/keystone-error.log
    CustomLog /var/log/httpd/keystone-access.log combined
</VirtualHost>

<VirtualHost *:35357>
    WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
    WSGIProcessGroup keystone-admin
    WSGIScriptAlias / /var/www/cgi-bin/keystone/admin
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    LogLevel info
    ErrorLogFormat "%{cu}t %M"
    ErrorLog /var/log/httpd/keystone-error.log
    CustomLog /var/log/httpd/keystone-access.log combined
</VirtualHost>
EOT

mkdir -p /var/www/cgi-bin/keystone
curl http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/kilo \
  | tee /var/www/cgi-bin/keystone/main /var/www/cgi-bin/keystone/admin
chown -R keystone:keystone /var/www/cgi-bin/keystone
chmod 755 /var/www/cgi-bin/keystone/*

systemctl enable httpd.service
systemctl start httpd.service

export OS_TOKEN=RANDOM_TOKEN
export OS_URL=http://controller:35357/v2.0
openstack service create --name keystone \
  --description "OpenStack Identity" identity
openstack endpoint create \
  --publicurl http://controller:5000/v2.0 \
  --internalurl http://controller:5000/v2.0 \
  --adminurl http://controller:35357/v2.0 \
  --region RegionOne \
  identity

openstack project create --description "Admin Project" admin
openstack user create --password ADMIN_PASS admin
openstack role create admin
openstack role add --project admin --user admin admin
openstack project create --description "Service Project" service
openstack project create --description "Demo Project" demo
openstack user create --password DEMO_PASS demo
openstack role create _member_
openstack role add --project demo --user demo _member_

unset OS_TOKEN OS_URL

cat <<EOT >> /home/vagrant/admin-openrc.sh
export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=admin
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_AUTH_URL=http://controller:35357/v3
EOT

cat <<EOT >> /home/vagrant/demo-openrc.sh
export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=demo
export OS_TENANT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=DEMO_PASS
export OS_AUTH_URL=http://controller:5000/v3
EOT
