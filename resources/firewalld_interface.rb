provides :firewalld_interface
unified_mode true

property :interface, [String, Array],
  coerce: proc { |x| x.is_a?(String) ? Array(x.split(', ')) : [x].flatten },
  name_property: true,
  description: 'The network interface(s) to manage'

property :zone, String,
  description: 'firewalld zone to add or remove interface from'

load_current_value do |desired|
  firewall_cmd_path = shell_out('which firewall-cmd')
  if firewall_cmd_path.stdout =~ %r{bin/firewall-cmd}
    current_state = []
    zone_text = desired.zone ? "--zone=#{desired.zone}" : ''
    desired.interface.each do |i|
      firewalld_interface_state = shell_out("firewall-cmd --permanent #{zone_text} --query-interface=#{i}")
      unless firewalld_interface_state.stdout =~ /no/
        current_state.push(i)
      end
    end
    interface current_state
  else
    raise Chef::Exceptions::ValidationFailed, 'firewall-cmd is unavailable on this system, please validate that firewalld is installed'
  end
end

action :add do
  converge_if_changed :interface do
    cmd = "firewall-cmd #{zone_ref(new_resource.zone)} --add-interface=#{new_resource.interface.join(' --add-interface=')}; "
    cmd += "firewall-cmd --permanent #{zone_ref(new_resource.zone)} --add-interface=#{new_resource.interface.join(' --add-interface=')}"
    shell_out!(cmd)
  end
end

action :change do
  converge_if_changed :interface do
    cmd = "firewall-cmd #{zone_ref(new_resource.zone)} --change-interface=#{new_resource.interface.join(' --change-interface=')}; "
    cmd += "firewall-cmd --permanent #{zone_ref(new_resource.zone)} --change-interface=#{new_resource.interface.join(' --change-interface=')}"
    shell_out!(cmd)
  end
end

action :remove do
  if current_resource.interface == new_resource.interface
    converge_by "Removing \"#{new_resource.interface}\" interface rules#{zone_desc(new_resource.zone)}" do
      cmd = "firewall-cmd #{zone_ref(new_resource.zone)} --remove-interface=#{new_resource.interface.join(' --remove-interface=')}; "
      cmd += "firewall-cmd --permanent #{zone_ref(new_resource.zone)} --remove-interface=#{new_resource.interface.join(' --remove-interface=')}"
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
