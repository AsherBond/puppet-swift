# == Class: swift::deps
#
#  swift anchors and dependency management
#
class swift::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'swift::install::begin': }
  -> Package<| tag == 'swift-package'|>
  ~> anchor { 'swift::install::end': }
  -> anchor { 'swift::config::begin': }
  -> Swift_config<||>
  ~> anchor { 'swift::config::end': }
  ~> anchor { 'swift::service::begin': }
  ~> Service<| tag == 'swift-service' |>
  ~> anchor { 'swift::service::end': }
  ~> Swift_dispersion_config<||>

  Anchor['swift::config::begin'] -> Swift_proxy_config<||> -> Anchor['swift::config::end']
  Swift_proxy_config<||> ~> Service<| tag == 'swift-proxy-service' |>

  Anchor['swift::config::begin'] -> Swift_ceilometer_config<||> -> Anchor['swift::config::end']
  Swift_ceilometer_config<||> ~> Service<| tag == 'swift-proxy-service' |>

  Anchor['swift::config::begin'] -> Swift_storage_policy<||> -> Anchor['swift::config::end']
  # storage policy is now used by proxy and object
  Swift_storage_policy<||> ~> Service<| tag == 'swift-proxy-service' |>
  Swift_storage_policy<||> ~> Service<| tag == 'swift-object-service' |>

  Anchor['swift::config::begin'] -> Swift_object_config<||> -> Anchor['swift::config::end']
  Swift_object_config<||> ~> Service<| tag == 'swift-object-service' |>

  Anchor['swift::config::begin'] -> Swift_container_config<||> -> Anchor['swift::config::end']
  Swift_container_config<||> ~> Service<| tag == 'swift-container-service' |>

  Anchor['swift::config::begin'] -> Swift_account_config<||> -> Anchor['swift::config::end']
  Swift_account_config<||> ~> Service<| tag == 'swift-account-service' |>

  Anchor['swift::config::begin'] -> Swift_internal_client_config<||> ~> Anchor['swift::config::end']

  # On any uwsgi config change, we must restart Swift.
  Anchor['swift::config::begin'] -> Swift_proxy_uwsgi_config<||> -> Anchor['swift::config::end']
  Swift_proxy_uwsgi_config<||> ~> Service<| tag == 'swift-proxy-service' |>

  Anchor['swift::config::begin'] -> Swift_account_uwsgi_config<||> -> Anchor['swift::config::end']
  Swift_account_uwsgi_config<||> ~> Service<| tag == 'swift-account-service' |>

  Anchor['swift::config::begin'] -> Swift_container_uwsgi_config<||> -> Anchor['swift::config::end']
  Swift_container_uwsgi_config<||> ~> Service<| tag == 'swift-container-service' |>

  # drive-audit.conf is not used by swift services, so any change in the file
  # should not trigger restarting services.
  Anchor['swift::config::begin'] -> Swift_drive_audit_config<||> -> Anchor['swift::config::end']

  # Support packages need to be installed in the install phase, but we don't
  # put them in the chain above because we don't want any false dependencies
  # between packages with the swift-package tag and the swift-support-package
  # tag.  Note: the package resources here will have a 'before' relationship on
  # the swift::install::end anchor.  The line between swift-support-package and
  # swift-package should be whether or not swift services would need to be
  # restarted if the package state was changed.
  Anchor['swift::install::begin']
  -> Package<| tag == 'swift-support-package'|>
  -> Anchor['swift::install::end']

  # Installation or config changes will always restart services.
  Anchor['swift::install::end'] ~> Anchor['swift::service::begin']
  Anchor['swift::config::end']  ~> Anchor['swift::service::begin']

}
