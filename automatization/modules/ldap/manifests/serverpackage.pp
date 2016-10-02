class ldap::serverpackage 
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
}