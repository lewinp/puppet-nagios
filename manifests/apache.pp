class nagios::apache (
  $puppet_manage_config = $nagios::apache::params::puppet_manage_config,
  $use_defaults  = $nagios::apache::params::use_defaults,
) inherits nagios::apache::params {
  
  class { 'nagios':
    nagios_httpd         => 'apache',
    puppet_manage_config => $puppet_manage_config,
    use_defaults         => $use_defaults,
  }

  include apache
  include apache::mod::php
  
  /*fixme! */
  #$vdir  = '/etc/apache2/sites-enabled/'
  #'www-data'
  case $::osfamily {
    RedHat: {
      $vdir  = '/etc/httpd/conf.d'
      $group = 'apache'
      $owner = 'apache'
    }
    Debian: {
      $vdir  = '/etc/apache2/sites-enabled'
      $group = 'www-data'
      $owner = 'www-data'
    }
  }

  case $::osfamily {
    RedHat: {
      file { "${nagios::base::nagios_cfgdir}/apache2.conf":
      #apache::conf { 'nagios':
        ensure => present,
        source => ["puppet:///modules/site-nagios/configs/${::fqdn}/apache2.conf",
                   'puppet:///modules/site-nagios/configs/apache2.conf',
                   "puppet:///modules/site-nagios/apache/${::osfamily}/apache2.conf",
                   "puppet:///modules/nagios/apache/${::osfamily}/apache2.conf"],
      }

      file { "$vdir/nagios3.conf":
        ensure => link,
        target => "${nagios::base::nagios_cfgdir}/apache2.conf",
        require => File["${nagios::base::nagios_cfgdir}/apache2.conf"],
      }
    }
    Debian: {
      file { "${nagios::base::nagios_cfgdir}/apache2.conf":
        ensure => present,
        source => ["puppet:///modules/site-nagios/configs/${::fqdn}/apache2.conf",
                   'puppet:///modules/site-nagios/configs/apache2.conf',
                   "puppet:///modules/site-nagios/apache/${::osfamily}/apache2.conf",
                   "puppet:///modules/nagios/apache/${::osfamily}/apache2.conf"],
      }

      notify{"$vdir/nagios3.conf": }
      file { "$vdir/nagios3.conf":
        ensure => link,
        target => "${nagios::base::nagios_cfgdir}/apache2.conf",
        require => File["${nagios::base::nagios_cfgdir}/apache2.conf"],
      }
    }
  }

  file { 'nagios_htpasswd':
    path => $nagios::params::htpasswd,
    ensure => file,
    source => ["puppet:///modules/site-nagios/configs/${::fqdn}/nagios_htpasswd",
               'puppet:///modules/site-nagios/configs/nagios_htpasswd',
               "puppet:///modules/site-nagios/apache/${::osfamily}/nagios_htpasswd",
               "puppet:///modules/nagios/apache/${::osfamily}/nagios_htpasswd"],
    mode => 0640,
    owner => $owner,
    group => $group,
  }
}
