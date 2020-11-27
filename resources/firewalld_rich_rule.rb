# To learn more about Custom Resources, see https://docs.chef.io/custom_resources/
provides :firewalld_rich_rule
resource_name :firewalld_rich_rule
unified_mode true

property :service_name, String,
  description: ''

property :family, String,
  equal_to: %w( ipv4 ipv6 ),
  default: 'ipv4',
  description: 'IP family. Choice of "ipv4" or "ipv6"'

property :zone, String,
  default: 'drop',
  description: 'The zone to remove or add a rule from'

property :source_address, String,
  description: 'Limits the origin of a connection attempt to a specific range of IPs'

property :destination_address, String,
  description: 'Limits the target of a connection attempt to a specific range of IPs'

property :port_number, Integer,
  description: 'Can be a single integer or a port range, for example 5060-5062. The protocol can be specified. Requires that port_protocol attribute be specified also'

property :port_protocol, String,
  default: 'tcp',
  description: 'The protocol for the specified port, can be "tcp" or "udp". Requires that port_number attribute be specified also.'

property :log_prefix, String,
  description: 'Logs new connection attempts with kernel logging. This will prepend the log lines with this prefix.'

property :log_level, String,
  equal_to: %w( emerg alert error warning notice info debug),
  description: "Can be one of 'emerg', 'alert', 'error', 'warning', 'notice', 'info', or 'debug'."

property :limit_value, String,
  description: 'Limits the rate at which logs are written.'

property :firewall_action, String,
  equal_to: %w( accept reject drop ),
  description: "Can be one of 'accept', 'reject', or 'drop'. This is the behavior by which all traffic that matches the rule will be handled."

load_current_value do |desired|
  cmd = 'rule '
  cmd += "family='#{desired.family}' " if desired.family
  cmd += "source address='#{desired.source_address}' " if desired.source_address
  cmd += "destination address='#{desired.destination_address}' " if desired.destination_address
  cmd += "service name='#{desired.service_name}' " if desired.service_name
  cmd += "port port='#{desired.port_number}' protocol='#{desired.port_protocol}' " if desired.port_number && desired.port_protocol
  cmd += "protocol value='#{desired.port_protocol}' " if desired.port_protocol && !desired.port_number
  cmd += 'log ' if desired.log_prefix || desired.log_level || desired.limit_value
  cmd += "prefix='#{desired.log_prefix}' " if desired.log_prefix
  cmd += "level='#{desired.log_level}' " if desired.log_level
  cmd += "limit value='#{desired.limit_value}' " if desired.limit_value
  cmd += desired.firewall_action if desired.firewall_action

  firewall_cmd_path = shell_out('which firewall-cmd')
  if firewall_cmd_path.stdout =~ %r{bin/firewall-cmd}
    firewalld_rich_rule_state = shell_out("firewall-cmd --permanent #{zone_ref(desired.zone)} --query-rich-rule=\"#{cmd}\"")
    if firewalld_rich_rule_state.stdout =~ /no/
      current_value_does_not_exist!
    else
      service_name desired.service_name
      family desired.family
      source_address desired.source_address
      destination_address desired.destination_address
      port_number desired.port_number
      port_protocol desired.port_protocol
      log_prefix desired.log_prefix
      log_level desired.log_level
      limit_value desired.limit_value
      firewall_action desired.firewall_action
    end
  else
    raise Chef::Exceptions::ValidationFailed, 'firewall-cmd is unavailable on this system, please validate that firewalld is installed'
  end
end

action :add do
  converge_if_changed :service_name, :family, :source_address, :destination_address, :port_number, :port_protocol, :log_prefix, :log_level, :limit_value, :firewall_action do
    cmd = "firewall-cmd #{zone_ref(new_resource.zone)} --add-rich-rule=\"#{rule_cmd}\"; "
    cmd += "firewall-cmd --permanent #{zone_ref(new_resource.zone)} --add-rich-rule=\"#{rule_cmd}\""
    shell_out!(cmd)
  end
end

action :remove do
  unless shell_out("firewall-cmd --permanent #{zone_ref(new_resource.zone)} --query-rich-rule=\"#{rule_cmd}\"").stdout =~ /no/
    converge_by "Removing rich rule configuration#{zone_desc(new_resource.zone)}" do
      cmd = "firewall-cmd #{zone_ref(new_resource.zone)} --remove-rich-rule=\"#{rule_cmd}\"; "
      cmd += "firewall-cmd --permanent #{zone_ref(new_resource.zone)} --remove-rich-rule=\"#{rule_cmd}\""
      shell_out!(cmd)
    end
  end
end

def zone_ref(my_zone)
  if zone.nil?
    ''
  else
    "--zone=#{my_zone}"
  end
end

def zone_desc(my_zone)
  if my_zone.nil?
    ''
  else
    " from zone: \"#{my_zone}\""
  end
end

action_class do
  def rule_cmd
    cmd = 'rule '
    cmd += "family='#{new_resource.family}' " if new_resource.family
    cmd += "source address='#{new_resource.source_address}' " if new_resource.source_address
    cmd += "destination address='#{new_resource.destination_address}' " if new_resource.destination_address
    cmd += "service name='#{new_resource.service_name}' " if new_resource.service_name
    cmd += "port port='#{new_resource.port_number}' protocol='#{new_resource.port_protocol}' " if new_resource.port_number && new_resource.port_protocol
    cmd += "protocol value='#{new_resource.port_protocol}' " if new_resource.port_protocol && !new_resource.port_number
    cmd += 'log ' if new_resource.log_prefix || new_resource.log_level || new_resource.limit_value
    cmd += "prefix='#{new_resource.log_prefix}' " if new_resource.log_prefix
    cmd += "level='#{new_resource.log_level}' " if new_resource.log_level
    cmd += "limit value='#{new_resource.limit_value}' " if new_resource.limit_value
    cmd += new_resource.firewall_action if new_resource.firewall_action
    cmd
  end
end