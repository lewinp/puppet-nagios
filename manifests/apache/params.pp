class nagios::apache::params {
  include nagios::params
  
  $puppet_manage_config = $nagios::params::puppet_manage_config

  $use_defaults         = $nagios::params::use_defaults
}