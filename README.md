vagrant-puppet-webdev
===

Vagrantfile + Puppet for provisioning simple LAMP development VM's

INSTALL
---

* `git clone` or download latest tarball
* `vagrant up` to provision VM

INFO 
---

The following packages will be installed on the VM:

* Debian Squeeze 64bit
* apache2, libapache2-mod-php5
* curl
* git
* mysql-server
* php-apc, php-pear, php5, php5-cli, php5-curl, php5-dev, php5-gd, php5-mcrypt, php5-mysql, php5-xdebug
* vim
* zsh

Additionally, after installing all the packages, my [dotfiles](https://github.com/cgdangelo/dotfiles) are downloaded and installed.