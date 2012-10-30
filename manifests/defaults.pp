class nagios::defaults {

  # include some default nagios objects

  include nagios::defaults::commands
  include nagios::defaults::contactgroups
  include nagios::defaults::contacts
  include nagios::defaults::hostgroups
  include nagios::defaults::templates
  include nagios::defaults::timeperiods
  include nagios::defaults::plugins
  
  case $::operatingsystem {
    'ubuntu': {
      /* Workaround Ubuntu */
      file {[
        "${nagios::base::nagios_cfgdir}/resource.cfg", 
        "${nagios::base::nagios_cfgdir}/conf.d/generic-service_nagios2.cfg", 
        "${nagios::base::nagios_cfgdir}/conf.d/contacts_nagios2.cfg", 
        "${nagios::base::nagios_cfgdir}/conf.d/hostgroups_nagios2.cfg", 
        "${nagios::base::nagios_cfgdir}/conf.d/timeperiods_nagios2.cfg", 
        "${nagios::base::nagios_cfgdir}/conf.d/generic-host_nagios2.cfg", 
        "${nagios::base::nagios_cfgdir}/conf.d/extinfo_nagios2.cfg", 
        "${nagios::base::nagios_cfgdir}/conf.d/localhost_nagios2.cfg", 
        "${nagios::base::nagios_cfgdir}/conf.d/services_nagios2.cfg", 
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
  }
}
