# To learn more about Custom Resources, see https://docs.chef.io/custom_resources/
provides :firewalld_service
resource_name :firewalld_service
unified_mode true

property :service, String,
  name_property: true,
  description: 'The Firewalld service to be added or removed from a zone'

property :zone, String,
  default: 'drop',
  description: 'The zone to remove or add a service rule for'

load_current_value do |desired|
  firewalld_service_state = shell_out("firewall-cmd --permanent --zone=#{desired.zone} --query-service=#{desired.service}")
  if firewalld_service_state.stdout =~ /yes/
    service desired.service
  else
    service ''
  end
end

action :add do
  converge_if_changed :service do
    cmd = "firewall-cmd --zone=#{new_resource.zone} --add-service=#{new_resource.service}; "
    cmd += "firewall-cmd --permanent --zone=#{new_resource.zone} --add-service=#{new_resource.service}"
    shell_out!(cmd)
  end
end

action :remove do
  if current_resource.service == new_resource.service
    converge_by "Removing \"#{new_resource.service}\" service from Zone \"#{new_resource.zone}\"" do
      cmd = "firewall-cmd --zone=#{new_resource.zone} --remove-service=#{new_resource.service}; "
      cmd += "firewall-cmd --permanent --zone=#{new_resource.zone} --remove-service=#{new_resource.service}"
      shell_out!(cmd)
    end
  end
end
