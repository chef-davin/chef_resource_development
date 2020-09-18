# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
template '/etc/ssh/sshd_config' do
  source 'sshd_config.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    ciphers: node['cis_rhel_hardening']['sshd']['ciphers'],
    kex_algorithms: node['cis_rhel_hardening']['sshd']['kex_algorithms'],
    macs: node['cis_rhel_hardening']['sshd']['macs'],
    log_level: node['cis_rhel_hardening']['sshd']['log_level'],
    login_grace_time: node['cis_rhel_hardening']['sshd']['login_grace_time'],
    host_based_auth: node['cis_rhel_hardening']['sshd']['host_based_authentication'],
    ignore_rhosts: node['cis_rhel_hardening']['sshd']['ignore_rhosts'],
    permit_empty_passwords: node['cis_rhel_hardening']['sshd']['permit_empty_passwords'],
    permit_user_environment: node['cis_rhel_hardening']['sshd']['permit_user_environment'],
    client_alive_interval: node['cis_rhel_hardening']['sshd']['client_alive_interval'],
    client_alive_count_max: node['cis_rhel_hardening']['sshd']['client_alive_count_max'],
    allow_groups: node['cis_rhel_hardening']['sshd']['allow_groups']
  )
  action :create
end
