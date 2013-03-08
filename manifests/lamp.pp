class other {
  $packages = [
    "curl",
    "vim"
  ]

  exec { "apt-get update":
    command => "/usr/bin/apt-get update"
  }

  package { $packages:
    ensure => present,
    require => Exec["apt-get update"]
  }
}

class apache {
  package { "apache2":
    ensure => present,
  }

  file { "/etc/apache2/mods-enabled/rewrite.load":
    ensure => link,
    target => "/etc/apache2/mods-available/rewrite.load",
    require => Package["apache2"]
  }

  file { "/etc/apache2/mods-enabled/headers.load":
    ensure => link,
    target => "/etc/apache2/mods-available/headers.load",
    require => Package["apache2"]
  }

  file { "/etc/apache2/sites-available/vagrant_webroot":
    ensure => present,
    source => "/vagrant/manifests/vagrant_webroot",
    require => Package["apache2"]
  }

  file { "/etc/apache2/sites-enabled/000-default":
    ensure => link,
    target => "/etc/apache2/sites-available/vagrant_webroot",
    require => File["/etc/apache2/sites-available/vagrant_webroot"]
  }

  file { "/etc/apache2/envvars":
    ensure => present,
    source => "/vagrant/manifests/envvars",
    owner => "root",
    group => "root",
    require => Package["apache2"]
  }

  service { "apache2":
    ensure => running,
    require => Package["apache2"],
    subscribe => [
      File["/etc/apache2/mods-enabled/rewrite.load"],
      File["/etc/apache2/mods-enabled/headers.load"],
      File["/etc/apache2/sites-available/vagrant_webroot"]
    ]
  }
}

class php {
  $packages = [
    "php5",
    "php5-cli",
    "php5-mysql",
    "php-pear",
    "php5-dev",
    "php-apc",
    "php5-mcrypt",
    "php5-gd",
    "php5-curl",
    "php5-xdebug",
    "libapache2-mod-php5"
  ]

  package { $packages:
    ensure => present,
    require => Exec["apt-get update"]
  }
}

class mysql {
  package { "mysql-server":
    ensure => present,
    require => Exec["apt-get update"]
  }

  service { "mysql":
    ensure => running,
    require => Package["mysql-server"]
  }

  exec { "set-mysql-password":
    unless  => "mysql -uroot -proot",
    path    => ["/bin", "/usr/bin"],
    command => "mysqladmin -uroot password root",
    require => Service["mysql"],
  }
}

class groups {
  group { "puppet":
    ensure => present,
  }
}

class charles {
  $packages = [
    "git",
    "zsh"
  ]
  
  package { $packages:
    ensure => present
  }

  exec { "change shell":
    path => ["/usr/bin", "/bin"],
    command => "chsh -s /bin/zsh vagrant",
    require => Package["zsh"]
  }

  exec { "install git-flow":
    path => ["/usr/bin", "/bin"],
    command => "wget --no-check-certificate -q -O - https://raw.github.com/nvie/gitflow/develop/contrib/gitflow-installer.sh | sudo bash",
    require => Package["git"]
  }
  
  exec { "install oh-my-zsh":
    path => ["/usr/bin", "/bin"],
    command => "curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh",
    require => Package["curl", "git", "zsh"],
    user => "vagrant"
  }

  exec { "grab dotfiles":
    path => ["/usr/bin", "/bin"],
    command => "git clone --recursive git://github.com/cgdangelo/dotfiles.git /tmp/dotfiles",
    require => Package["git"]
  }
  
  exec { "use dotfiles":
    require => Exec["grab dotfiles"],
    path => ["/usr/bin", "/bin"],
    command => "rsync -vr /tmp/dotfiles/ /home/vagrant/"
  }
  
  exec { "remove dotfiles repo":
    require => Exec["use dotfiles"],
    path => ["/usr/bin", "/bin"],
    command => "rm -rf /home/vagrant/.git"
  }
  
  exec { "clean tmp dir":
    require => Exec["remove dotfiles repo"],
    path => ["/usr/bin", "/bin"],
    command => "rm -rf /tmp/dotfiles"
  }
}

include other
include apache
include php
include mysql
include groups
include charles
