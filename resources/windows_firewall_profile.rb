provides :windows_firewall_profile

unified_mode true

property :profile, String,
  name_property: true,
  equal_to: %w{ Domain Public Private },
  description: "Set the Windows Profile being configured"

property :default_inbound_action, String,
  equal_to: %w{ Allow Block NotConfigured },
  description: "Set the default policy for inbound network traffic"

property :default_outbound_action, String,
  equal_to: %w{ Allow Block NotConfigured },
  description: "Set the default policy for outbound network traffic"

property :allow_inbound_rules, [true, false, String], equal_to: [true, false, "NotConfigured"], description: "Allow users to set inbound firewall rules"
property :allow_local_firewall_rules, [true, false, String], equal_to: [true, false, "NotConfigured"], description: "Merges inbound firewall rules into the policy"
property :allow_local_ipsec_rules, [true, false, String], equal_to: [true, false, "NotConfigured"], description: "Allow users to manage local connection security rules"
property :allow_user_apps, [true, false, String], equal_to: [true, false, "NotConfigured"], description: "Allow user applications to manage firewall"
property :allow_user_ports, [true, false, String], equal_to: [true, false, "NotConfigured"], description: "Allow users to manage firewall port rules"
property :allow_unicast_response, [true, false, String], equal_to: [true, false, "NotConfigured"], description: "Allow unicast responses to multicast and broadcast messages"
property :display_notification, [true, false, String], equal_to: [true, false, "NotConfigured"], description: "Display a notification when firewall blocks certain activity"

load_current_value do |desired|
  ps_get_net_fw_profile = load_firewall_state(desired.profile)
  output = powershell_out(ps_get_net_fw_profile)
  if output.stdout.empty?
    current_value_does_not_exist!
  else
    state = Chef::JSONCompat.from_json(output.stdout)
  end

  default_inbound_action state["default_inbound_action"]
  default_outbound_action state["default_outbound_action"]
  allow_inbound_rules pwsh_convert(state["allow_inbound_rules"])
  allow_local_firewall_rules pwsh_convert(state["allow_local_firewall_rules"])
  allow_local_ipsec_rules pwsh_convert(state["allow_local_ipsec_rules"])
  allow_user_apps pwsh_convert(state["allow_user_apps"])
  allow_user_ports pwsh_convert(state["allow_user_ports"])
  allow_unicast_response pwsh_convert(state["allow_unicast_response"])
  display_notification pwsh_convert(state["display_notification"])
end
def pwsh_convert(obj)
  if obj.to_s.downcase == "true"
    true
  elsif obj.to_s.downcase == "false"
    false
  elsif obj.to_s.downcase == "notconfigured"
    "NotConfigured"
  end
end

def ruby_convert(obj)
  if obj.to_s.downcase == "true"
    "True"
  elsif obj.to_s.downcase == "false"
    "False"
  elsif obj.to_s.downcase == "notconfigured"
    "NotConfigured"
  end
end

def load_firewall_state(profile_name)
  <<-EOH
    Remove-TypeData System.Array # workaround for PS bug here: https://bit.ly/2SRMQ8M
    $#{profile_name} = Get-NetFirewallProfile -Profile #{profile_name}
    ([PSCustomObject]@{
      default_inbound_action = $#{profile_name}.DefaultInboundAction.ToString()
      default_outbound_action = $#{profile_name}.DefaultOutboundAction.ToString()
      allow_inbound_rules = $#{profile_name}.AllowInboundRules.ToString()
      allow_local_firewall_rules = $#{profile_name}.AllowLocalFirewallRules.ToString()
      allow_local_ipsec_rules = $#{profile_name}.AllowLocalIPsecRules.ToString()
      allow_user_apps = $#{profile_name}.AllowUserApps.ToString()
      allow_user_ports = $#{profile_name}.AllowUserPorts.ToString()
      allow_unicast_response = $#{profile_name}.AllowUnicastResponseToMulticast.ToString()
      display_notification = $#{profile_name}.NotifyOnListen.ToString()
    }) | ConvertTo-Json
  EOH
end


action :enable do
  converge_if_changed :default_inbound_action, :default_outbound_action, :allow_inbound_rules, :allow_local_firewall_rules,
    :allow_local_ipsec_rules, :allow_user_apps, :allow_user_ports, :allow_unicast_response, :display_notification do
      fw_cmd = firewall_command(new_resource.profile)
      powershell_out!(fw_cmd)
    end
  unless firewall_enabled?(new_resource.profile)
    converge_by "Enable the #{new_resource.profile} Firewall Profile" do
      cmd = "Set-NetFirewallProfile -Profile #{new_resource.profile} -Enabled \"True\""
      powershell_out!(cmd)
    end
  end
end

action :disable do
  if firewall_enabled?(new_resource.profile)
    converge_by "Disable the #{new_resource.profile} Firewall Profile" do
      cmd = "Set-NetFirewallProfile -Profile #{new_resource.profile} -Enabled \"False\""
      powershell_out!(cmd)
    end
  end
end

action_class do
  def firewall_command(fw_profile)
    cmd = "Set-NetFirewallProfile -Profile \"#{fw_profile}\""
    cmd << " -DefaultInboundAction \"#{new_resource.default_inbound_action}\"" unless new_resource.default_inbound_action.nil?
    cmd << " -DefaultOutboundAction \"#{new_resource.default_outbound_action}\"" unless new_resource.default_outbound_action.nil?
    cmd << " -AllowInboundRules \"#{ruby_convert(new_resource.allow_inbound_rules)}\"" unless new_resource.allow_inbound_rules.nil?
    cmd << " -AllowLocalFirewallRules \"#{ruby_convert(new_resource.allow_local_firewall_rules)}\"" unless new_resource.allow_local_firewall_rules.nil?
    cmd << " -AllowLocalIPsecRules \"#{ruby_convert(new_resource.allow_local_ipsec_rules)}\"" unless new_resource.allow_local_ipsec_rules.nil?
    cmd << " -AllowUserApps \"#{ruby_convert(new_resource.allow_user_apps)}\"" unless new_resource.allow_user_apps.nil?
    cmd << " -AllowUserPorts \"#{ruby_convert(new_resource.allow_user_ports)}\"" unless new_resource.allow_user_ports.nil?
    cmd << " -AllowUnicastResponseToMulticast \"#{ruby_convert(new_resource.allow_unicast_response)}\"" unless new_resource.allow_unicast_response.nil?
    cmd << " -NotifyOnListen \"#{ruby_convert(new_resource.display_notification)}\"" unless new_resource.display_notification.nil?
  end

  def firewall_enabled?(profile_name)
    cmd = <<~CODE
      $#{profile_name} = Get-NetFirewallProfile -Profile #{profile_name}
      if ($#{profile_name}.Enabled) {
          return $true
      } else {return $false}
    CODE
    firewall_status = powershell_out(cmd).stdout
    if firewall_status =~ /True/
      true
    elsif firewall_status =~ /False/
      false
    end
  end
end