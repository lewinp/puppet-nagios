class nagios::base (
  $nagios_cfgdir        = $nagios::base::params::nagios_cfgdir,
  $puppet_manage_config = $nagios::puppet_manage_config,
  $use_defaults         = $nagios::use_defaults,
) inherits nagios::base::params {

  if $use_defaults {
    include nagios::defaults
  }

  group { 'nagios':
    ensure => 'present',
    gid    => '117',
  }

  if $puppet_manage_config {
    if $use_defaults {
      Package['nagios'] {
        /* TODO: Very dirty workaround (Package install fail if nagios objects are not present ) */
        require => Nagios_command['check-host-alive'],
      }
    }
  }

  package { 'nagios':
    ensure  => present,
    alias   => 'nagios',
  }

  service { 'nagios':
    ensure => running,
    enable => true,
    #hasstatus => true, #fixme!
    require => Package['nagios'],
  }

  if $puppet_manage_config {
    # this file should contain all the nagios_puppet-paths:
    file { 'nagios_main_cfg':
      path   => "$nagios_cfgdir/nagios.cfg",
      source => [ "puppet:///modules/site-nagios/configs/${fqdn}/nagios.cfg",
                  "puppet:///modules/site-nagios/configs/${::operatingsystem}/nagios.cfg",
                  "puppet:///modules/site-nagios/configs/nagios.cfg",
                  "puppet:///modules/nagios/configs/${::operatingsystem}/nagios.cfg",
                  "puppet:///modules/nagios/configs/nagios.cfg" ],
      notify => Service['nagios'],
      mode   => 0644,
      owner  => 'root',
      group  => 'root',
    }

    file { 'nagios_cgi_cfg':
      path   => "$nagios_cfgdir/cgi.cfg",
      source => [ "puppet:///modules/site-nagios/configs/${fqdn}/cgi.cfg",
                  "puppet:///modules/site-nagios/configs/${::operatingsystem}/cgi.cfg",
                  "puppet:///modules/site-nagios/configs/cgi.cfg",
                  "puppet:///modules/nagios/configs/${::operatingsystem}/cgi.cfg",
                  "puppet:///modules/nagios/configs/cgi.cfg" ],
      mode   => '0644',
      owner  => 'root',
      group  => 'root',
      notify => Service['httpd'],
    }

    file { 'nagios_private':
      ensure  => directory,
      path    => "$nagios_cfgdir/private/",
      purge   => true,
      recurse => true,
      notify  => Service['nagios'],
      require => Group['nagios'],
      mode    => '0750',
      owner   => 'root',
      group   => 'nagios',
    }

    file { 'nagios_private_resource_cfg':
      path    => "$nagios_cfgdir/private/resource.cfg",
      source  => [ "puppet:///modules/site-nagios/configs/${::operatingsystem}/private/resource.cfg.${::architecture}",
                   "puppet:///modules/nagios/configs/${::operatingsystem}/private/resource.cfg.${::architecture}" ],
      notify  => Service['nagios'],
      require => Group['nagios'],
      owner   => 'root',
      group   => 'nagios',
      mode    => '0640',
    }

    file { 'nagios_confd':
      ensure  => directory,
      path    => "$nagios_cfgdir/conf.d/",
      purge   => true,
      recurse => true,
      notify   => Service['nagios'],
      require => Group['nagios'],
      mode    => '0750',
      owner   => 'root',
      group   => 'nagios',
    }

    Nagios_command <<||>>
    Nagios_contactgroup <<||>>
    Nagios_contact <<||>>
    Nagios_hostdependency <<||>>
    Nagios_hostescalation <<||>>
    Nagios_hostextinfo <<||>>
    Nagios_hostgroup <<||>>
    Nagios_host <<||>>
    Nagios_servicedependency <<||>>
    Nagios_serviceescalation <<||>>
    Nagios_servicegroup <<||>>
    Nagios_serviceextinfo <<||>>
    Nagios_service <<||>>
    Nagios_timeperiod <<||>>

    Nagios_command <||> {
      target  => "$nagios_cfgdir/conf.d/nagios_command.cfg",
      require => File['nagios_confd'],
      notify  => Service['nagios'],
    }
    Nagios_contact <||> {
      target  => "$nagios_cfgdir/conf.d/nagios_contact.cfg",
      require => File['nagios_confd'],
      notify  => Service['nagios'],
    }
    Nagios_contactgroup <||> {
      target  => "$nagios_cfgdir/conf.d/nagios_contactgroup.cfg",
      require => File['nagios_confd'],
      notify  => Service['nagios'],
    }
    Nagios_host <||> {
      target  => "$nagios_cfgdir/conf.d/nagios_host.cfg",
      require => File['nagios_confd'],
      notify  => Service['nagios'],
    }
    Nagios_hostdependency <||> {
      target  => "$nagios_cfgdir/conf.d/nagios_hostdependency.cfg",
      require => File['nagios_confd'],
      notify  => Service['nagios'],
    }
    Nagios_hostescalation <||> {
      target  => "$nagios_cfgdir/conf.d/nagios_hostescalation.cfg",
      require => File['nagios_confd'],
      notify  => Service['nagios'],
    }
    Nagios_hostextinfo <||> {
      target  => "$nagios_cfgdir/conf.d/nagios_hostextinfo.cfg",
      require => File['nagios_confd'],
      notify  => Service['nagios'],
    }
    Nagios_hostgroup <||> {
      target  => "$nagios_cfgdir/conf.d/nagios_hostgroup.cfg",
      require => File['nagios_confd'],
      notify  => Service['nagios'],
    }
    Nagios_service <||> {
      target  => "$nagios_cfgdir/conf.d/nagios_service.cfg",
      require => File['nagios_confd'],
      notify  => Service['nagios'],
    }
    Nagios_servicegroup <||> {
      target  => "$nagios_cfgdir/conf.d/nagios_servicegroup.cfg",
      require => File['nagios_confd'],
      notify  => Service['nagios'],
    }
    Nagios_servicedependency <||> {
      target  => "$nagios_cfgdir/conf.d/nagios_servicedependency.cfg",
      require => File['nagios_confd'],
      notify  => Service['nagios'],
    }
    Nagios_serviceescalation <||> {
      target  => "$nagios_cfgdir/conf.d/nagios_serviceescalation.cfg",
      require => File['nagios_confd'],
      notify  => Service['nagios'],
    }
    Nagios_serviceextinfo <||> {
      target  => "$nagios_cfgdir/conf.d/nagios_serviceextinfo.cfg",
      require => File['nagios_confd'],
      notify  => Service['nagios'],
    }
    Nagios_timeperiod <||> {
      target  => "$nagios_cfgdir/conf.d/nagios_timeperiod.cfg",
      require => File['nagios_confd'],
      notify  => Service['nagios'],
    }

    file{[ "$nagios_cfgdir/conf.d/nagios_command.cfg", 
           "$nagios_cfgdir/conf.d/nagios_contact.cfg", 
           "$nagios_cfgdir/conf.d/nagios_contactgroup.cfg",
           "$nagios_cfgdir/conf.d/nagios_host.cfg",
           "$nagios_cfgdir/conf.d/nagios_hostdependency.cfg",
           "$nagios_cfgdir/conf.d/nagios_hostescalation.cfg",
           "$nagios_cfgdir/conf.d/nagios_hostextinfo.cfg",
           "$nagios_cfgdir/conf.d/nagios_hostgroup.cfg",
           "$nagios_cfgdir/conf.d/nagios_hostgroupescalation.cfg",
           "$nagios_cfgdir/conf.d/nagios_service.cfg",
           "$nagios_cfgdir/conf.d/nagios_servicedependency.cfg",
           "$nagios_cfgdir/conf.d/nagios_serviceescalation.cfg",
           "$nagios_cfgdir/conf.d/nagios_serviceextinfo.cfg",
           "$nagios_cfgdir/conf.d/nagios_servicegroup.cfg",
           "$nagios_cfgdir/conf.d/nagios_timeperiod.cfg" ]:
      ensure  => file,
      replace => false,
      notify  => Service['nagios'],
      mode    => '0644',
      owner   => 'root',
      group   => 0,
    }

    # manage nagios cfg files
    # must be defined after exported resource overrides and cfg file defs
    file { 'nagios_cfgdir':
      ensure  => directory,
      path    => "$nagios_cfgdir/",
      recurse => true,
      purge   => true,
      notify  => Service['nagios'],
      mode    => 0755,
      owner   => 'root',
      group   => 'root';
    }

  }
  else {
    file { 'nagios_cfgdir':
      ensure  => directory,
      path    => "$nagios_cfgdir/",
      mode    => 0755,
      owner   => 'root',
      group   => 'root';
    }
    
    file { 'nagios_main_cfg':
      path    => "$nagios_cfgdir/nagios.cfg",
      notify  => Service['nagios'],
      mode    => 0644,
      owner   => 'root',
      group   => 'root',
      require => [ File['nagios_cfgdir'], Package['nagios'] ], 
    }
  } 

  if $::use_munin {
    include nagios::munin
  }
}
