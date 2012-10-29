class nagios::base::ubuntu inherits nagios::base::debian {
  /* Workaround Ubuntu */
  file{[
    "${nagios::defaults::vars::int_nagios_cfgdir}/resource.cfg", 
    "${nagios::defaults::vars::int_nagios_cfgdir}/conf.d/generic-service_nagios2.cfg", 
    "${nagios::defaults::vars::int_nagios_cfgdir}/conf.d/contacts_nagios2.cfg", 
    "${nagios::defaults::vars::int_nagios_cfgdir}/conf.d/hostgroups_nagios2.cfg", 
    "${nagios::defaults::vars::int_nagios_cfgdir}/conf.d/timeperiods_nagios2.cfg", 
    "${nagios::defaults::vars::int_nagios_cfgdir}/conf.d/generic-host_nagios2.cfg", 
    "${nagios::defaults::vars::int_nagios_cfgdir}/conf.d/extinfo_nagios2.cfg", 
    "${nagios::defaults::vars::int_nagios_cfgdir}/conf.d/localhost_nagios2.cfg", 
    "${nagios::defaults::vars::int_nagios_cfgdir}/conf.d/services_nagios2.cfg", 
  ]:
    ensure  => file,
    content => '',
    require => Group['nagios'],
    mode    => 0644,
    owner   => 'root',
    group   => 'nagios',
    notify  => Package['nagios'],
  }
}
