# # puppet agent service

class puppet::agent (
  $enable = 'running',
  $ensure = true) inherits puppet::params {

  #input validation
#  validate_bool($ensure)
#  validate_string($enable)

  service { 'puppet':
    ensure  => $ensure,
    enable  => $enable,
    require => Class['puppet::config']
  }

}
