# Class: loopback
# ===========================
#
# Full description of class loopback here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'loopback':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Catalin Trifu <ctrifu@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class loopback(
  $devices = {},
) inherits loopback::params {
  validate_hash($devices)

  if size($devices) != 0 {
    # install only if we have devices
    include loopback::install
  }

  define loopack_device() {
  }

  $devices.each | $base_dir, $content | {
    file { $base_dir:
      ensure  => directory,
      owner   => $content['owner'],
      group   => $content['group'],
      recurse => true,
    }

    $content['files'].each | $loopback_file, $sz | {
      exec { $loopback_file:
        command => "/usr/bin/dd if=/dev/zero of=${base_dir}/${loopback_file} bs=1M count=${sz}",
        creates => "${base_dir}/${loopback_file}",
      }
    }

    $fileno = 0
    file { '/etc/systemd/scripts/loopback-setup':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template("${module_name}/loopback-setup.erb"),
    }
    $fileno = 0
    file { '/etc/udev/rules.d/50-loop.rules':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/udev/rules.d/50-loop.rules.erb"),
    }
  }
}
