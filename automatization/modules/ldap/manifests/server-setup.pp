#
#
class ldap::server-setup {
  
  $tmppath = '/tmp/passwd'
  
  exec { "slappasswd -s p@$\$w0rd > $tmppath":
    creates => $tmppath,
    path    => ['/usr/sbin']
  }
  
  $pass = file($tmppath)
  
  file {'/etc/openldap/slapd.d':
   ensure  => absent,
   recurse => true,
   purge   => true,
   force   => true,
   require  => Exec["slappasswd -s p@$\$w0rd > $tmppath"]
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