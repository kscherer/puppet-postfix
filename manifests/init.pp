# == Class: postfix
#
class postfix (
  $package_ensure           = 'present',
  $package_name             = $::postfix::params::package_name,
  $package_list             = $::postfix::params::package_list,

  $config_dir_path          = $::postfix::params::config_dir_path,
  $config_dir_purge         = false,
  $config_dir_recurse       = true,
  $config_dir_source        = undef,

  $config_file_path         = $::postfix::params::config_file_path,
  $config_file_owner        = $::postfix::params::config_file_owner,
  $config_file_group        = $::postfix::params::config_file_group,
  $config_file_mode         = $::postfix::params::config_file_mode,
  $config_file_source       = undef,
  $config_file_string       = undef,
  $config_file_template     = undef,

  $config_file_notify       = $::postfix::params::config_file_notify,
  $config_file_require      = $::postfix::params::config_file_require,

  $config_file_hash         = {},
  $config_file_options_hash = {},

  $service_ensure           = 'running',
  $service_name             = $::postfix::params::service_name,
  $service_enable           = true,

  $myhostname               = $::fqdn,
  $mydestination            = "${::fqdn}, localhost.${::domain}, localhost",
  $recipient                = "admin@${::domain}",
  $relayhost                = "smtp.${::domain}",
  $relayport                = 25,
  $sasl_user                = undef,
  $sasl_pass                = undef,
) inherits ::postfix::params {
  $config_file_content = default_content($config_file_string, $config_file_template)

  if $config_file_hash {
    create_resources('postfix::define', $config_file_hash)
  }

  if $package_ensure == 'absent' {
    $config_dir_ensure  = 'directory'
    $config_file_ensure = 'present'
    $_service_ensure    = 'stopped'
    $_service_enable    = false
  } elsif $package_ensure == 'purged' {
    $config_dir_ensure  = 'absent'
    $config_file_ensure = 'absent'
    $_service_ensure    = 'stopped'
    $_service_enable    = false
  } else {
    $config_dir_ensure  = 'directory'
    $config_file_ensure = 'present'
    $_service_ensure    = $service_ensure
    $_service_enable    = $service_enable
  }

  anchor { 'postfix::begin': } ->
  class { '::postfix::install': } ->
  class { '::postfix::config': } ~>
  class { '::postfix::service': } ->
  anchor { 'postfix::end': }
}
