class nagios::base::params {
  case $::operatingsystem {
    centos: {
      $nagios_cfgdir = '/etc/nagios'
    }
    default: {
      $nagios_cfgdir = '/etc/nagios3'
    }
  }
}
