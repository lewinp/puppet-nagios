define nagios::plugin(
    $source = 'absent',
    $ensure = present
){
  $nagios_plugin_path = $hardwaremodel ? {
    'x86_64' => "/usr/lib64/nagios/plugins/$name",
    default  => "/usr/lib/nagios/plugins/$name",
  }

  $nagios_plugin_source = $source ? {
    'absent' => "puppet:///modules/nagios/plugins/$name",
    default => "puppet:///modules/$source"
  }

  file{$name:
    ensure  => $ensure,
    path    => $nagios_plugin_path,
    source  => $nagios_plugin_source,
    tag     => 'nagios_plugin',
    require => Package['nagios-plugins'],
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
}
