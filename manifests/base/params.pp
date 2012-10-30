class nagios::base::params {
  case $::operatingsystem {
    centos: {
      $nagios_cfgdir = '/etc/nagios'
    }
    default: {
      $nagios_cfgdir = '/etc/nagios3'
    }
  }

  $puppet_manage_config = true
}
