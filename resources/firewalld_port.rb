# To learn more about Custom Resources, see https://docs.chef.io/custom_resources/
provides :firewalld_port
resource_name :firewalld_port
unified_mode true

property :port, [String, Array],
  coerce: proc { |x| x.is_a?(String) ? Array(x.split(', ')) : [x].flatten },
  name_property: true,
  description: 'The Firewalld port(s) to be added or removed as an allowed port'

property :zone, String,
  default: 'drop',
  description: 'The zone to remove or add a port rule for'

load_current_value do |desired|
  firewall_cmd_path = shell_out('which firewall-cmd')
  if firewall_cmd_path.stdout =~ %r{bin/firewall-cmd}
    current_state = []
    desired.port.each do |i|
      firewalld_port_state = shell_out("firewall-cmd --permanent #{zone_ref(desired.zone)} --query-port=#{i}")
      unless firewalld_port_state.stdout =~ /no/
        current_state.push(i)
      end
    end
    port current_state
  else
    raise Chef::Exceptions::ValidationFailed, 'firewall-cmd is unavailable on this system, please validate that firewalld is installed'
  end
end

action :add do
  converge_if_changed :port do
    cmd = "firewall-cmd #{zone_ref(new_resource.zone)} --add-port=#{new_resource.port.join(' --add-port=')}; "
    cmd += "firewall-cmd --permanent #{zone_ref(new_resource.zone)} --add-port=#{new_resource.port.join(' --add-port=')}"
    shell_out!(cmd)
  end
end

action :remove do
  if current_resource.port == new_resource.port
    converge_by "Removing \"#{new_resource.port}\" port rules#{zone_desc(new_resource.zone)}" do
      cmd = "firewall-cmd #{zone_ref(new_resource.zone)} --remove-port=#{new_resource.port.join(' --remove-port=')}; "
      cmd += "firewall-cmd --permanent #{zone_ref(new_resource.zone)} --remove-port=#{new_resource.port.join(' --remove-port=')}"
      shell_out!(cmd)
    end
  end
end

def zone_ref(my_zone)
  if my_zone.nil?
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