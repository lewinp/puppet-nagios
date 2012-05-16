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
  $htpasswd = $::osfamily ? {
    RedHat => '/etc/nagios/passwd',
    Debian => '/etc/nagios3/htpasswd.users',
    default => '/etc/nagios/passwd',
  }
}
