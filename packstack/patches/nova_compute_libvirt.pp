--- a/usr/lib/python2.7/site-packages/packstack/puppet/templates/nova_compute_libvirt.pp 2014-11-27 12:01:06.809154108 +0000
+++ b/usr/lib/python2.7/site-packages/packstack/puppet/templates/nova_compute_libvirt.pp 2014-11-27 12:01:19.744114919 +0000
@@ -3,7 +3,7 @@
 # Ensure Firewall changes happen before libvirt service start
 # preventing a clash with rules being set by libvirt
 
-if $::is_virtual_packstack == "true" {
+if $::is_virtual == "true" {
     $libvirt_virt_type = "qemu"
     $libvirt_cpu_mode = "none"
 }else{
