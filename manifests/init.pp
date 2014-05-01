class puppet {

  class{'puppet::facts':} ->
  class{'puppet::install':} ->
  class{'puppet::config':} ->
  class{'puppet::agent':} ->
  class{'puppet::backup':} ->
  Class['puppet']

}
