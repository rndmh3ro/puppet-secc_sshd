# SecC Linux SSH Hardening
class secc_sshd (
  $ext_admin_interface           = ['eth0'],
  $ext_admininterface_nr         = '0',
  $ext_admininterface_xen0       = 'xenbr0',
  $ext_setListenAddress          = true,
  $ext_sshd_AllowUsers           = 'root rootuser',
  $ext_sshd_AllowGroups          = '',
  $ext_sshd_DenyUsers            = '',
  $ext_sshd_DenyGroups           = '',
  $ext_sshd_KexAlgorithms        = 'diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1',
  $ext_sshd_AllowTcpForwarding   = 'no',
  $ext_sshd_AllowAgentForwarding = 'no',
  $ext_sshd_Ciphers              = 'aes256-ctr',
  $ext_sshd_MACs                 = 'hmac-sha2-512,hmac-sha2-256',
  $ext_sshd_AuthorizedKeysFile   = '.ssh/authorized_keys',
  $ext_ssh_KexAlgorithms         = 'diffie-hellman-group-exchange-sha256',
  $ext_ssh_Ciphers               = 'aes256-ctr',
  $ext_ssh_MACs                  = 'hmac-sha2-512,hmac-sha2-256',
  $ext_servicename               = 'change me - Servicename',
  $ext_issue_banner              = true,
) {
  
  
  if ($ext_admininterface_nr) {
    fail('using variable ext_admininterface_nr is deprecated, cancel puppet run | please use ext_admin_interface')
  }
  
  if ($ext_admininterface_xen0) {
    fail('using variable ext_admininterface_xen0 is deprecated, cancel puppet run | please use ext_admin_interface')
  }

  $admin_interface           = hiera(admin_interface, $ext_admin_interface)
  $admininterface_nr         = hiera(admininterface_nr, $ext_admininterface_nr)
  $admininterface_xen0       = hiera(admininterface_xen0, $ext_admininterface_xen0)
  $setListenAddress          = hiera(setListenAddress, $ext_setListenAddress)
  $sshd_AllowUsers           = hiera(sshd_AllowUsers, $ext_sshd_AllowUsers)
  $sshd_AllowGroups          = hiera(sshd_AllowGroups, $ext_sshd_AllowGroups)
  $sshd_DenyUsers            = hiera(sshd_DenyUsers, $ext_sshd_DenyUsers)
  $sshd_DenyGroups           = hiera(sshd_DenyGroups, $ext_sshd_DenyGroups)
  $sshd_KexAlgorithms        = hiera(sshd_KexAlgorithm, $ext_sshd_KexAlgorithms)
  $sshd_AllowTcpForwarding   = hiera(sshd_AllowTcpForwarding, $ext_sshd_AllowTcpForwarding)
  $sshd_AllowAgentForwarding = hiera(sshd_AllowAgentForwarding, $ext_sshd_AllowAgentForwarding)
  $sshd_Ciphers              = hiera(sshd_Ciphers, $ext_sshd_Ciphers)
  $sshd_MACs                 = hiera(sshd_MACs, $ext_sshd_MACs)
  $sshd_AuthorizedKeysFile   = hiera(sshd_AuthorizedKeysFile, $ext_sshd_AuthorizedKeysFile)
  $ssh_KexAlgorithms         = hiera(ssh_KexAlgorithm, $ext_ssh_KexAlgorithms)
  $ssh_Ciphers               = hiera(ssh_Ciphers, $ext_ssh_Ciphers)
  $ssh_MACs                  = hiera(ssh_MACs, $ext_ssh_MACs)
  $servicename               = hiera(servicename, $ext_servicename)
  $issue_banner              = hiera(issue_banner, $ext_issue_banner)
  include secc_sshd::install

  class { 'secc_sshd::config':
    admin_interface           => $admin_interface,
    admininterface_nr         => $admininterface_nr,
    admininterface_xen0       => $admininterface_xen0,
    setListenAddress          => $setListenAddress,
    sshd_AllowUsers           => $sshd_AllowUsers,
    sshd_AllowGroups          => $sshd_AllowGroups,
    sshd_DenyUsers            => $sshd_DenyUsers,
    sshd_DenyGroups           => $sshd_DenyGroups,
    sshd_KexAlgorithms        => $sshd_KexAlgorithms,
    sshd_AllowTcpForwarding   => $sshd_AllowTcpForwarding,
    sshd_AllowAgentForwarding => $sshd_AllowAgentForwarding,
    sshd_Ciphers              => $sshd_Ciphers,
    sshd_MACs                 => $sshd_MACs,
    sshd_AuthorizedKeysFile   => $sshd_AuthorizedKeysFile,
    servicename               => $servicename,
    issue_banner              => $issue_banner,
    require                   => Class['secc_sshd::install'],
    notify                    => Class['secc_sshd::service'],
  }

  include secc_sshd::service

  class { 'secc_sshd::ssh_config':
    ssh_KexAlgorithms => $ssh_KexAlgorithms,
    ssh_Ciphers       => $ssh_Ciphers,
    ssh_MACs          => $ssh_MACs,
  }

}
