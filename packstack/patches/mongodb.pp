--- a/usr/lib/python2.7/site-packages/packstack/puppet/templates/mongodb.pp	2014-11-27 11:58:21.315655405 +0000
+++ b/usr/lib/python2.7/site-packages/packstack/puppet/templates/mongodb.pp	2014-11-27 11:58:30.509627554 +0000
@@ -1,4 +1,14 @@
+case $::operatingsystem {
+    'Fedora': {
+        $pidfilepath = '/var/run/mongodb/mongodb.pid'
+    }
+    default: {
+        $pidfilepath = '/var/run/mongodb/mongod.pid'
+    }
+}
+
 class { 'mongodb::server':
     smallfiles   => true,
     bind_ip      => ['%(CONFIG_MONGODB_HOST)s'],
+    pidfilepath  => $pidfilepath,
 }
