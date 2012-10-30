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
  $vdir  = '/etc/apache2/sites-enabled/'
  $group = 'www-data'

  case $::osfamily {
    RedHat: {
      apache::conf { 'nagios':
        source => ["puppet:///modules/site-nagios/configs/${::fqdn}/apache2.conf",
                   'puppet:///modules/site-nagios/configs/apache2.conf',
                   "puppet:///modules/site-nagios/apache/${::osfamily}/apache2.conf",
                   "puppet:///modules/nagios/apache/${::osfamily}/apache2.conf"],
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
    content => '',
    mode => 0640,
    owner => root,
    group => $group,
  }
}
