# lvm_physical_volume ['/dev/sdb', '/dev/sdc'] do
#   action :create
# end
apt_update 'name' do
  ignore_failure true
  action :update
end

package 'firewalld' do
  action :install
end

service 'firewalld' do
  action [:enable, :start]
end

firewalld_service %w(ssh smtp http https snmp) do
  zone 'public'
  action :add
end

firewalld_service 'https' do
  zone 'drop'
  action :add
end

firewalld_service %w(smtp http snmp) do
  zone 'drop'
  action :remove
end

firewalld_service 'http' do
  action :remove
end

firewalld_port ['9200/tcp', '9231/udp', '2222/tcp', '8888/tcp'] do
  action :add
end

firewalld_port '9631/tcp' do
  action :add
end

firewalld_port '8080/tcp' do
  action :remove
end

firewalld_interface 'eth0' do
  action :add
end

firewalld_interface ['eth1', 'eth2'] do
  zone 'drop'
  action :add
end

firewalld_interface 'eth0' do
  action :remove
end

firewalld_rich_rule 'special http1' do
  zone 'public'
  family 'ipv4'
  port_number 8808
  port_protocol 'tcp'
  source_address '0.0.0.0/0'
  log_prefix 'special_http_app'
  log_level 'info'
  limit_value '1/m'
  firewall_action 'accept'
  action :add
end

firewalld_rich_rule 'special http2' do
  zone 'public'
  family 'ipv4'
  port_number 8880
  port_protocol 'tcp'
  source_address '0.0.0.0/0'
  log_prefix 'special_http_app'
  log_level 'info'
  limit_value '1/m'
  firewall_action 'accept'
  action :add
end

firewalld_rich_rule 'special http3' do
  zone 'public'
  family 'ipv4'
  port_number 8880
  port_protocol 'tcp'
  source_address '0.0.0.0/0'
  log_prefix 'special_http_app'
  log_level 'info'
  limit_value '1/m'
  firewall_action 'accept'
  action :remove
end

firewalld_zone 'public' do
  default true
  target 'default'
  action :create
end

firewalld_zone 'dmz' do
  target 'ACCEPT'
  default false
  action :create_if_missing
end

firewalld_zone 'domino' do
  target 'ACCEPT'
  default false
  action :create
end

firewalld_zone 'domino' do
  target 'default'
  default false
  action :create_if_missing
end

firewalld_zone 'rally' do
  target 'ACCEPT'
  default true
  action :create_if_missing
end

firewalld_zone 'domino' do
  action :delete
end

firewalld_zone 'rally' do
  action :delete
end
