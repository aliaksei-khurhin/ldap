#
#
class ldap::server
(
  $pass = sha1digest("p@$\$w0rd")
)
{
  $pack = {
    'openldap-servers' => '2.4.40-12.el6',
    'openldap-clients' => '2.4.40-12.el6',
    'phpldapadmin'     => '1.2.3-1.el6'
  }
  $pack.each | $p, $v | {
    package { $p:
      ensure => $v
    }
  }
  
  file {'/etc/openldap/slapd.d':
   ensure  => absent,
   recurse => true,
   purge   => true,
   force   => true,
   require  => Package['openldap-servers']
 }
  
  file { '/etc/openldap/slapd.conf':
    ensure  => file,
    content => template('ldap/slapd.erb'),
    owner   => ldap,
    group   => ldap,
    mode    => '0644',
    backup  => false,
    require => File['/etc/openldap/slapd.d']
  }

  service { 'slapd':
    ensure  => 'running',
    enable  => 'true',
    require => File['/etc/openldap/slapd.conf']
  }

}
