class puppet::master (
  $puppetdb = true,
  $puppetboard = true,
) inherits puppet::params {

  class{'puppet':} ->
  class{'puppet::master::install':} ->
  class{'puppet::master::modules':} ->
  class{'puppet::master::config':} ->
  class{'puppet::master::hiera':} ->
  class{'puppet::master::passenger':} ->
  Class['puppet::master']

  if ($puppetdb == true) {
    require puppet::master::puppetdb
  }
  if ( $puppetboard == true ) {
    require puppet::master::puppetboard
  }

}
