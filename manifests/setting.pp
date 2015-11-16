# Define: puppet::setting
#
# define for adding setting to puppet.conf
#

define puppet::setting (
  $value,
  $section,
  $ensure  = present,
) {
  include ::puppet::defaults
  $confdir = $puppet::defaults::confdir

  ini_setting { "puppet ${section} ${title}":
    ensure  => $ensure,
    path    => "${confdir}/puppet.conf",
    section => $section,
    setting => $title,
    value   => $value,
  }

}
