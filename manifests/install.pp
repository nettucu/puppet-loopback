class loopback::install () {
  file {'/etc/systemd/scripts':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
  }

  file { 'loopback.service':
    ensure => present,
    path   => '/etc/systemd/system/loopback.service',
    owner  => 'root',
    group  => 'root',
    mode   => '0664',
    source => "puppet:///modules/${module_name}/loopback.service",
  }

  exec { 'systemd-daemon-reload':
    command => '/usr/bin/systemctl daemon-reload',
    require => File['loopback.service'],
  }
}
