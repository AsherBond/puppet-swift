#
# Configure ceilometer middleware for swift
#
# == Dependencies
#
# puppet-ceilometer (http://github.com/enovance/puppet-ceilometer)
#
# == Parameters
#
# [*password*]
#   (Required) The password for the user
#
# [*default_transport_url*]
#   (Required) A URL representing the messaging driver to use and its full
#   configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#
# [*driver*]
#   (Optional) The Drivers(s) to handle sending notifications.
#   Defaults to undef.
#
# [*topic*]
#   (Optional) AMQP topic used for OpenStack notifications.
#   Defaults to undef.
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped.
#   Defaults to $facts['os_service_default'].
#
# [*ensure*]
#   Enable or not ceilometer fragment
#   Defaults to 'present'
#
# [*nonblocking_notify*]
#   Whether to send events to messaging driver in a background thread
#   Defaults to $facts['os_service_default'].
#
# [*ignore_projects*]
#   What projects to ignore to send events to ceilometer
#   Defaults to ['services']
#
# [*auth_url*]
#   (Optional) The URL to use for authentication.
#   Defaults to 'http://127.0.0.1:5000'
#
# [*auth_type*]
#   (Optional) The plugin for authentication
#   Defaults to 'password'
#
# [*project_name*]
#   (Optional) Service project name
#   Defaults to 'services'
#
# [*project_domain_name*]
#   (Optional) name of domain for $project_name
#   Defaults to 'default'
#
# [*system_scope*]
#   (Optional) Scope for system operations
#   Defaults to $facts['os_service_default']
#
# [*username*]
#   (Optional) The name of the service user
#   Defaults to 'swift'
#
# [*user_domain_name*]
#   (Optional) name of domain for $username
#   Defaults to 'default'
#
# [*region_name*]
#   (Optional) The region in which the identity server can be found.
#   Defaults to $facts['os_service_default'].
#
# [*notification_ssl_ca_file*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   (string value)
#   Defaults to $facts['os_service_default']
#
# [*notification_ssl_cert_file*]
#   (optional) SSL cert file. (string value)
#   Defaults to $facts['os_service_default']
#
# [*notification_ssl_key_file*]
#   (optional) SSL key file. (string value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_use_ssl*]
#   (Optional) Connect over SSL for RabbitMQ. (boolean value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions. (string value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_ha_queues*]
#   (Optional) Use HA queues in RabbitMQ (x-ha-policy: all). If you change this
#   option, you must wipe the RabbitMQ database. (boolean value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_queue*]
#   (Optional) Use quorum queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_transient_quorum_queue*]
#   (Optional) Use quorum queues for transients queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_transient_queues_ttl*]
#   (Optional) Positive integer representing duration in seconds for
#   queue TTL (x-expires). Queues which are unused for the duration
#   of the TTL are automatically deleted.
#   The parameter affects only reply and fanout queues. (integer value)
#   Min to 1
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_delivery_limit*]
#   (Optional) Each time a message is rdelivered to a consumer, a counter is
#   incremented. Once the redelivery count exceeds the delivery limit
#   the message gets dropped or dead-lettered.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (Optional) Number of seconds after which the Rabbit broker is
#   considered down if heartbeat's keep-alive fails
#   (0 disable the heartbeat). EXPERIMENTAL. (integer value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_rate*]
#   (Optional) How often times during the heartbeat_timeout_threshold
#   we check the heartbeat. (integer value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_qos_prefetch_count*]
#   (Optional) Specifies the number of messages to prefetch.
#   Defaults to $facts['os_service_default']
#
# [*amqp_durable_queues*]
#   (optional) Define queues as "durable" to rabbitmq.
#   Defaults to $facts['os_service_default']
#
# [*amqp_auto_delete*]
#   (Optional) Define if transient queues should be auto-deleted (boolean value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_reconnect_delay*]
#   (Optional) How long to wait before reconnecting in response
#   to an AMQP consumer cancel notification. (floating point value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $facts['os_service_default']
#
# DEPRECATED PARAMETERS
#
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
#   Defaults to undef
#
# == Examples
#
# == Authors
#
#   Francois Charlier fcharlier@enovance.com
#
# == Copyright
#
# Copyright 2013 eNovance licensing@enovance.com
#
class swift::proxy::ceilometer(
  String[1] $password,
  String[1] $default_transport_url,
  $driver                             = $facts['os_service_default'],
  $topic                              = $facts['os_service_default'],
  $control_exchange                   = $facts['os_service_default'],
  $ensure                             = 'present',
  $nonblocking_notify                 = $facts['os_service_default'],
  $ignore_projects                    = ['services'],
  $auth_url                           = 'http://127.0.0.1:5000',
  $auth_type                          = 'password',
  $project_name                       = 'services',
  $project_domain_name                = 'Default',
  $system_scope                       = $facts['os_service_default'],
  $username                           = 'swift',
  $user_domain_name                   = 'Default',
  $region_name                        = $facts['os_service_default'],
  $notification_ssl_ca_file           = $facts['os_service_default'],
  $notification_ssl_cert_file         = $facts['os_service_default'],
  $notification_ssl_key_file          = $facts['os_service_default'],
  $rabbit_use_ssl                     = $facts['os_service_default'],
  $kombu_ssl_version                  = $facts['os_service_default'],
  $rabbit_ha_queues                   = $facts['os_service_default'],
  $rabbit_quorum_queue                = $facts['os_service_default'],
  $rabbit_transient_quorum_queue      = $facts['os_service_default'],
  $rabbit_transient_queues_ttl        = $facts['os_service_default'],
  $rabbit_quorum_delivery_limit       = $facts['os_service_default'],
  $rabbit_heartbeat_timeout_threshold = $facts['os_service_default'],
  $rabbit_heartbeat_rate              = $facts['os_service_default'],
  $rabbit_qos_prefetch_count          = $facts['os_service_default'],
  $amqp_durable_queues                = $facts['os_service_default'],
  $amqp_auto_delete                   = $facts['os_service_default'],
  $kombu_reconnect_delay              = $facts['os_service_default'],
  $kombu_failover_strategy            = $facts['os_service_default'],
  $kombu_compression                  = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  $rabbit_heartbeat_in_pthread        = undef,
) inherits swift {

  include swift::deps
  include swift::params

  Package['python-ceilometermiddleware'] ~> Service<| title == 'swift-proxy-server' |>

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $facts['os_service_default']
    $project_domain_name_real = $facts['os_service_default']
  }

  file { '/etc/swift/ceilometer.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => $::swift::params::group,
    mode    => '0640',
    require => Anchor['swift::config::begin'],
    before  => Anchor['swift::config::end'],
  }

  File['/etc/swift/ceilometer.conf'] -> Swift_ceilometer_config<||>

  swift_proxy_config {
    'filter:ceilometer/topic':                value => $topic;
    'filter:ceilometer/driver':               value => $driver;
    'filter:ceilometer/url':                  value => $default_transport_url, secret => true;
    'filter:ceilometer/control_exchange':     value => $control_exchange;
    'filter:ceilometer/paste.filter_factory': value => 'ceilometermiddleware.swift:filter_factory';
    'filter:ceilometer/nonblocking_notify':   value => $nonblocking_notify;
    'filter:ceilometer/ignore_projects':      value => join(any2array($ignore_projects), ',');
    'filter:ceilometer/auth_url':             value => $auth_url;
    'filter:ceilometer/auth_type':            value => $auth_type;
    'filter:ceilometer/project_name':         value => $project_name_real;
    'filter:ceilometer/project_domain_name':  value => $project_domain_name_real;
    'filter:ceilometer/system_scope':         value => $system_scope;
    'filter:ceilometer/username':             value => $username;
    'filter:ceilometer/user_domain_name':     value => $user_domain_name;
    'filter:ceilometer/password':             value => $password, secret => true;
    'filter:ceilometer/region_name':          value => $region_name;
    'filter:ceilometer/extra_config_files':   value => '/etc/swift/ceilometer.conf';
  }

  if $default_transport_url =~ /^rabbit.*/ {
    oslo::messaging::rabbit { 'swift_ceilometer_config':
      rabbit_ha_queues              => $rabbit_ha_queues,
      rabbit_quorum_queue           => $rabbit_quorum_queue,
      rabbit_transient_quorum_queue => $rabbit_transient_quorum_queue,
      rabbit_transient_queues_ttl   => $rabbit_transient_queues_ttl,
      rabbit_quorum_delivery_limit  => $rabbit_quorum_delivery_limit,
      heartbeat_timeout_threshold   => $rabbit_heartbeat_timeout_threshold,
      heartbeat_rate                => $rabbit_heartbeat_rate,
      heartbeat_in_pthread          => $rabbit_heartbeat_in_pthread,
      rabbit_qos_prefetch_count     => $rabbit_qos_prefetch_count,
      amqp_durable_queues           => $amqp_durable_queues,
      amqp_auto_delete              => $amqp_auto_delete,
      kombu_ssl_ca_certs            => $notification_ssl_ca_file,
      kombu_ssl_certfile            => $notification_ssl_cert_file,
      kombu_ssl_keyfile             => $notification_ssl_key_file,
      kombu_ssl_version             => $kombu_ssl_version,
      rabbit_use_ssl                => $rabbit_use_ssl,
      kombu_reconnect_delay         => $kombu_reconnect_delay,
      kombu_failover_strategy       => $kombu_failover_strategy,
      kombu_compression             => $kombu_compression,
    }
  } else {
    oslo::messaging::rabbit { 'swift_ceilometer_config': }
  }

  package { 'python-ceilometermiddleware':
    ensure => $ensure,
    name   => $::swift::params::ceilometermiddleware_package_name,
    tag    => ['openstack', 'swift-support-package'],
  }

}
