default['cis_rhel_hardening']['sshd']['ciphers'] = %w(aes128-ctr aes192-ctr aes256-ctr)
default['cis_rhel_hardening']['sshd']['kex_algorithms'] = ['curve25519-sha256@libssh.org', 'diffie-hellman-group-exchange-sha256']
default['cis_rhel_hardening']['sshd']['macs'] = ['hmac-sha2-512-etm@openssh.com', 'hmac-sha2-256-etm@openssh.com', 'umac-128-etm@openssh.com', 'hmac-sha2-512,hmac-sha2-256', 'umac-128@openssh.com']

default['cis_rhel_hardening']['sshd']['log_level'] = 'INFO'
default['cis_rhel_hardening']['sshd']['login_grace_time'] = '60'

default['cis_rhel_hardening']['sshd']['host_based_authentication'] = 'no'
default['cis_rhel_hardening']['sshd']['ignore_rhosts'] = 'yes'
default['cis_rhel_hardening']['sshd']['permit_empty_passwords'] = 'no'
default['cis_rhel_hardening']['sshd']['permit_user_environment'] = 'no'
default['cis_rhel_hardening']['sshd']['client_alive_interval'] = '300'
default['cis_rhel_hardening']['sshd']['client_alive_count_max'] = '0'
default['cis_rhel_hardening']['sshd']['allow_groups'] = %w(remote wheel)

default['cis_rhel_hardening']['sshd']['match_users'] = []
default['cis_rhel_hardening']['sshd']['match_users'] = {
  aribaqtg: {
    X11Forwarding: 'no',
    AllowTcpForwarding: 'no',
    ChrootDirectory: '/export/',
    ForceCommand: 'internal-sftp',
  },
  tidal: {
    X11Forwarding: 'no',
    AllowTcpForwarding: 'no',
    ChrootDirectory: '/export/',
    ForceCommand: 'internal-sftp',
  },
  hrdd: {
    X11Forwarding: 'no',
    AllowTcpForwarding: 'no',
    ChrootDirectory: '/export/',
    ForceCommand: 'internal-sftp',
  },
  snapqtg: {
    X11Forwarding: 'no',
    AllowTcpForwarding: 'no',
    ChrootDirectory: '/export/',
  },
}
