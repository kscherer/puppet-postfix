# == Define: postfix::define
#
define postfix::define (
  $config_file_path         = undef,
  $config_file_owner        = undef,
  $config_file_group        = undef,
  $config_file_mode         = undef,
  $config_file_source       = undef,
  $config_file_string       = undef,
  $config_file_template     = undef,

  $config_file_notify       = undef,
  $config_file_require      = undef,

  $config_file_options_hash = $::postfix::config_file_options_hash,
) {
  $_config_file_path  = pick($config_file_path, "${::postfix::config_dir_path}/${name}")
  $_config_file_owner = pick($config_file_owner, $::postfix::config_file_owner)
  $_config_file_group = pick($config_file_group, $::postfix::config_file_group)
  $_config_file_mode = pick($config_file_mode, $::postfix::config_file_mode)
  $config_file_content = default_content($config_file_string, $config_file_template)

  $_config_file_notify = pick($config_file_notify, $::postfix::config_file_notify)
  $_config_file_require = pick($config_file_require, $::postfix::config_file_require)

  file { "define_${name}":
    ensure  => $::postfix::config_file_ensure,
    path    => $_config_file_path,
    owner   => $_config_file_owner,
    group   => $_config_file_group,
    mode    => $_config_file_mode,
    source  => $config_file_source,
    content => $config_file_content,
    notify  => $_config_file_notify,
    require => $_config_file_require,
  }
}
