Vagrant LAMP
============

Creates a LAMP based server using Ubuntu 16.04, PHP 7 and MySQL 5.7

Requirements
------------
* VirtualBox <http://www.virtualbox.org>
* Vagrant <http://www.vagrantup.com>
* Git <http://git-scm.com/>

Usage
-----

### Startup

1. Download [https://github.com/lroot/lamp-vagrant/archive/master.zip](https://github.com/lroot/lamp-vagrant/archive/master.zip)
2. Extract the ZIP file.
3. From the command-line:
```
$ cd lamp-vagrant-master
$ vagrant up
```

### Connecting

#### Apache
The Apache server is available at <http://192.168.33.10>

#### MySQL
Externally the MySQL server is available at 192.168.33.10:3306
Username: root
Password: 12345678

Technical Details
-----------------
* Ubuntu 16.04 64-bit
* Apache 2.4
* PHP 7
* MySQL 5.7
* Composer