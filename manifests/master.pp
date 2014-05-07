class puppet::master (
  $puppetdb = $puppet::params::puppetdb,
  $puppetboard = $puppet::params::puppetboard,
) inherits puppet::params {

  class{'puppet':} ->
  class{'puppet::master::install':} ->
  class{'puppet::master::modules':} ->
  class{'puppet::master::config':} ->
  class{'puppet::master::hiera':} ->
  class{'puppet::master::passenger':} ->
  class{'puppet::master::backup':} ->
  Class['puppet::master']

  if ( $puppetdb == true ) {
    class{'puppet::master::puppetdb':}
  }
  if ( $puppetboard == true ) {
    class{'puppet::master::puppetboard':}
  }

}
