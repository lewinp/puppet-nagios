# manifests/target.pp

class nagios::target ( $ipv6 = false ) {

  @@nagios_host { "${fqdn}":
    address => $ipaddress,
    alias   => $hostname,
    use     => 'generic-host',
  }

  if ($::nagios_parents != '') {
    Nagios_host["${fqdn}"] { parents => $::nagios_parents }
  }

  if ($ipv6 == true) {
    @@nagios_host { "${fqdn}6":
      address => $ipaddress6,
      alias   => "${hostname}6",
      use     => 'generic-host',
    }
    if ($::nagios_parents != '') {
      Nagios_host["${fqdn}6"] { parents => $::nagios_parents }
    }
  }

}
