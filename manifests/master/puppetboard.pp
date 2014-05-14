## Class puppet::master::puppetboard

class puppet::master::puppetboard (
  $unresponsive = $puppet::master::params::unresponsive,
  $puppetboard_revision = $puppet::master::params::puppetboard_revision,
) inherits puppet::master::params {

  ## setup puppetboard
  class { '::python':
    dev        => true,
    pip        => true,
    virtualenv => true,
  } ->
  class { '::apache::mod::wsgi':
  } ->
  class { '::puppetboard':
    unresponsive => $unresponsive,
    revision     => $puppetboard_revision,
  } ->
  class { '::puppetboard::apache::vhost':
    vhost_name => 'pboard',
  }

}
