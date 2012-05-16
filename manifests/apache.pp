class nagios::apache {
  include nagios
  include apache
  include apache::php

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
      file { "${nagios::defaults::vars::int_nagios_cfgdir}/apache2.conf":
        ensure => present,
        source => ["puppet:///modules/site-nagios/configs/${::fqdn}/apache2.conf",
                   'puppet:///modules/site-nagios/configs/apache2.conf',
                   "puppet:///modules/site-nagios/apache/${::osfamily}/apache2.conf",
                   "puppet:///modules/nagios/apache/${::osfamily}/apache2.conf"],
      }

      file { "${apache::params::vdir}/nagios3.conf":
        ensure => link,
        target => "${nagios::defaults::vars::int_nagios_cfgdir}/apache2.conf",
        require => File["${nagios::defaults::vars::int_nagios_cfgdir}/apache2.conf"],
      }
    }
  }

  file { 'nagios_htpasswd':
    path => $nagios::params::htpasswd,
    ensure => file,
    content => template('nagios/apache/htpasswd.erb',
                        'site-nagios/apache/htpasswd.erb'),
    mode => 0640,
    owner => root,
    group => $apache::params::group,
  }
}
