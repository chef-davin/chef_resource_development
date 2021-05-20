
# systemd services
default['cis_rhel_hardening']['services']['avahi-daemon'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.3_ensure_avahi_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['cups'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.4_ensure_cups_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['dhcpd'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.5_ensure_DHCP_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['slapd'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.6_ensure_LDAP_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['nfs'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.7_ensure_nfs_and_rpc_are_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['nfs-server'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.7_ensure_nfs_and_rpc_are_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['rpcbind'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.7_ensure_nfs_and_rpc_are_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['named'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.8_ensure_dns_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['vsftpd'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.9_ensure_ftp_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['httpd'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.10_ensure_httpd_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['dovecot'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.11_ensure_imap3_and_pop3_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['smb'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.12_ensure_samba_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['squid'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.13_ensure_http_proxy_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['snmpd'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.14_ensure_snmp_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['ypserv'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.16_ensure_nis_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['rsh.socket'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.17_ensure_rsh_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['rlogin.socket'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.17_ensure_rsh_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['rexec.socket'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.17_ensure_rsh_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['ntalk'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.18_ensure_talk_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['telnet'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.19_ensure_telnet_server_is_not_enabled',
}
default['cis_rhel_hardening']['services']['tftp.socket'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.20_ensure_tftp_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['rsyncd'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.21_ensure_rsync_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['autofs'] = {
  type: 'systemd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.2.22_disable_automounting',
  justification: 'This service is not being managed by Chef',
}

# xinet.d services
default['cis_rhel_hardening']['services']['chargen-dgram'] = {
  type: 'xinetd',
  manage: true,
  action: :disable,
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.1.1_ensure_chargen_services_are_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['chargen-stream'] = {
  type: 'xinetd',
  manage: true,
  action: :disable,
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.1.1_ensure_chargen_services_are_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['daytime-dgram'] = {
  type: 'xinetd',
  manage: true,
  action: :disable,
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.1.2_ensure_daytime_services_are_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['daytime-stream'] = {
  type: 'xinetd',
  manage: true,
  action: :disable,
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.1.2_ensure_daytime_services_are_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['discard-dgram'] = {
  type: 'xinetd',
  manage: true,
  action: :disable,
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.1.3_ensure_discard_services_are_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['discard-stream'] = {
  type: 'xinetd',
  manage: true,
  action: :disable,
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.1.3_ensure_discard_services_are_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['echo-dgram'] = {
  type: 'xinetd',
  manage: true,
  action: :disable,
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.1.4_ensure_echo_services_are_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['echo-stream'] = {
  type: 'xinetd',
  manage: true,
  action: :disable,
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.1.4_ensure_echo_services_are_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['time-dgram'] = {
  type: 'xinetd',
  manage: true,
  action: :disable,
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.1.5_ensure_time_services_are_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['time-stream'] = {
  type: 'xinetd',
  manage: true,
  action: :disable,
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.1.5_ensure_time_services_are_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['tftp'] = {
  type: 'xinetd',
  manage: true,
  action: :disable,
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.1.6_ensure_tftp_server_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
default['cis_rhel_hardening']['services']['xinetd'] = {
  type: 'xinetd',
  manage: true,
  action: [:disable, :stop],
  control: 'xccdf_org.cisecurity.benchmarks_rule_2.1.7_ensure_xinetd_is_not_enabled',
  justification: 'This service is not being managed by Chef',
}
