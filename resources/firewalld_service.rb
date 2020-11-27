# To learn more about Custom Resources, see https://docs.chef.io/custom_resources/
provides :firewalld_service
resource_name :firewalld_service
unified_mode true

property :service, [String, Array],
  coerce: proc { |x| x.is_a?(String) ? Array(x.split(', ')) : [x].flatten },
  name_property: true,
  description: 'The Firewalld service(s) to be added or removed as an allowed service'

property :zone, String,
  default: 'drop',
  description: 'The zone to remove or add a service rule for'

load_current_value do |desired|
  firewall_cmd_path = shell_out('which firewall-cmd')
  if firewall_cmd_path.stdout =~ %r{bin/firewall-cmd}
    current_state = []
    desired.service.each do |i|
      firewalld_service_state = shell_out("firewall-cmd --permanent #{zone_ref(desired.zone)} --query-service=#{i}")
      unless firewalld_service_state.stdout =~ /no/
        current_state.push(i)
      end
    end
    service current_state
  else
    raise Chef::Exceptions::ValidationFailed, 'firewall-cmd is unavailable on this system, please validate that firewalld is installed'
  end
end

action :add do
  converge_if_changed :service do
    cmd = "firewall-cmd #{zone_ref(new_resource.zone)} --add-service=#{new_resource.service.join(' --add-service=')}; "
    cmd += "firewall-cmd --permanent #{zone_ref(new_resource.zone)} --add-service=#{new_resource.service.join(' --add-service=')}"
    shell_out!(cmd)
  end
end

action :remove do
  if current_resource.service == new_resource.service
    converge_by "Removing \"#{new_resource.service}\" service rules#{zone_desc(new_resource.zone)}" do
      cmd = "firewall-cmd #{zone_ref(new_resource.zone)} --remove-service=#{new_resource.service.join(' --remove-service=')}; "
      cmd += "firewall-cmd --permanent #{zone_ref(new_resource.zone)} --remove-service=#{new_resource.service.join(' --remove-service=')}"
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