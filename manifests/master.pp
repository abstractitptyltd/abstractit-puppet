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
  class{'puppet::master::backup':} ->
  class{'puppet::master::puppetdb':} ->
  Class['puppet::master']

  if ( $puppetboard == true ) {
    class{'puppet::master::puppetboard':}
  }

}
