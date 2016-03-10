class loopback::install () {
  file {
    '/etc/systemd/scripts':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0775';
    '/etc/udev/rules.d':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0775';
    '/etc/udev/scripts':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0775';
  }

  file {
    'loopback.service':
      ensure     => present,
      path       => '/etc/systemd/system/loopback.service',
      owner      => 'root',
      group      => 'root',
      mode       => '0664',
      source     => "puppet:///modules/${module_name}/loopback.service",
      require    => File['/etc/systemd/scripts'];
    'loop-setup':
      ensure  => present,
      path    => '/etc/udev/scripts/loop-setup',
      owner   => 'root',
      group   => 'root',
      mode    => '775',
      source  => "puppet:///modules/${module_name}/udev/scripts/loop-setup",
      require => File['/etc/udev/scripts'];
    '50-loop':
      ensure  => present,
      path    => '/etc/udev/rules.d/50-loop.rules',
      owner   => 'root',
      group   => 'root',
      mode    => '644',
      source  => "puppet:///modules/${module_name}/udev/rules.d/50-loop.rules",
      require => File['/etc/udev/rules.d'];
  }

  exec { 'systemd-daemon-reload':
    command => '/usr/bin/systemctl daemon-reload',
    require => File['loopback.service'],
  }
}
