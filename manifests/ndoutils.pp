class nagios::ndoutils (
  $mysql_database   = $nagios::ndoutils::params::mysql_database,
  $mysql_user       = $nagios::ndoutils::params::mysql_user,
  $mysql_password   = $nagios::ndoutils::params::mysql_password,
  $mysql_host       = $nagios::ndoutils::params::mysql_host,
  $config_overwrite = $nagios::ndoutils::params::config_overwrite,
  $config_owner     = $nagios::ndoutils::params::config_owner,
  $config_group     = $nagios::ndoutils::params::config_group,
) inherits nagios::ndoutils::params {

  mysql::db { $mysql_database:
    user     => $mysql_user,
    password => $mysql_password,
    host     => $mysql_host,
    grant    => ['all'],
    require  => Class['mysql::server'],
  }

  if $config_overwrite {
    file { '/etc/nagios3/ndo2db.cfg':
      ensure  => present,
      replace => $config_overwrite,
      owner   => $config_owner,
      group   => $config_group,
      mode    => '0600',
      content => template('nagios/ndoutils/ndo2db.cfg.erb'),
      notify  => Service['ndoutils'],
      require => Package['ndoutils'],
    }

    file { '/etc/nagios3/ndomod.cfg':
      ensure  => present,
      replace => $config_overwrite,
      owner   => $config_owner,
      group   => $config_group,
      mode    => '0644',
      content => template('nagios/ndoutils/ndomod.cfg.erb'),
      notify  => Service['ndoutils'],
      require => Package['ndoutils'],
    }

    file { '/etc/default/ndoutils':
      ensure  => present,
      replace => $config_overwrite,
      owner   => $config_owner,
      group   => $config_group,
      mode    => '0644',
      content => template('nagios/ndoutils/ndoutils.erb'),
      notify  => Service['ndoutils'],
      require => Package['ndoutils'],
    }
  }
  else {
    file { '/etc/nagios3/ndo2db.cfg':
      ensure  => present,
      replace => $config_overwrite,
      owner   => $config_owner,
      group   => $config_group,
      mode    => '0600',
      content => template('nagios/ndoutils/ndo2db.cfg.erb'),
      notify  => Service['ndoutils'],
    }

    file { '/etc/nagios3/ndomod.cfg':
      ensure  => present,
      replace => $config_overwrite,
      owner   => $config_owner,
      group   => $config_group,
      mode    => '0644',
      content => template('nagios/ndoutils/ndomod.cfg.erb'),
      notify  => Service['ndoutils'],
    }

    file { '/etc/default/ndoutils':
      ensure  => present,
      replace => $config_overwrite,
      owner   => $config_owner,
      group   => $config_group,
      mode    => '0644',
      content => template('nagios/ndoutils/ndoutils.erb'),
      notify  => Service['ndoutils'],
    }
  }

  $config_files = [
    '/etc/nagios3/ndo2db.cfg',
    '/etc/nagios3/ndomod.cfg',
    '/etc/default/ndoutils',
  ]

  $file = '/tmp/mysql.sql'

  if $config_overwrite {
    package { 'ndoutils':
      name    => 'ndoutils-nagios3-mysql',
      ensure  => present,
      require => [
        Class['mysql::server'],
        Package['nagios'],
      ],
    }
  }
  else {
    package { 'ndoutils':
      name    => 'ndoutils-nagios3-mysql',
      ensure  => present,
      require => [
        Class['mysql::server'],
        Package['nagios'],
        File[$config_files],
      ],
    }
  }

  file { $file:
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/nagios/ndoutils/db/mysql.sql',
  }

  exec { 'initialize-nagios-database':
    timeout => 120,
    command => "/usr/bin/mysql --user=$mysql_user --password=$mysql_password -D$mysql_database -h$mysql_host < $file",
    unless  => "/usr/bin/mysql --user=$mysql_user --password=$mysql_password -D$mysql_database -h$mysql_host -e 'SELECT * FROM nagios_dbversion LIMIT 1'",
    require => [
      Mysql::Db['nagios'],
      Package['ndoutils'],
      File['/tmp/mysql.sql'],
    ];
  }

  service { 'ndoutils':
    ensure    => running,
    enable    => true,
    hasstatus => false,
    notify    => Service['nagios'],
    require   => [
      Package['ndoutils'],
      Exec['initialize-nagios-database'],
    ],
  }
}