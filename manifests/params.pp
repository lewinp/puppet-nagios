# Class: nagios::params
#
# Hold parameters for nagios module
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nagios::params {
  $nagios_httpd = 'apache'

  $htpasswd = $::osfamily ? {
    RedHat => '/etc/nagios/passwd',
    Debian => '/etc/nagios3/htpasswd.users',
    default => '/etc/nagios/passwd',
  }

  $puppet_manage_config = true

  $use_defaults  = true
}
