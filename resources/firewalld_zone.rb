# To learn more about Custom Resources, see https://docs.chef.io/custom_resources/
provides :firewalld_zone
unified_mode true

property :zone, String,
  name_property: true,
  description: 'The zone name to manage'

property :default, [true, false],
  default: false,
  description: 'Use to make the zone the default zone'

property :target, String,
  equal_to: ['default', 'ACCEPT', 'DROP', '%%REJECT%%'],
  default: 'default',
  description: 'Use to make the zone the default zone'

load_current_value do |desired|
  firewall_cmd_path = shell_out('which firewall-cmd')
  if firewall_cmd_path.stdout =~ %r{bin/firewall-cmd}
    firewalld_zone_list = shell_out('firewall-cmd --permanent --get-zones').stdout.split(' ')

    if firewalld_zone_list.include? desired.zone
      zone desired.zone

      firewalld_zone_target = shell_out("firewall-cmd --permanent --zone=#{desired.zone} --get-target").stdout.chomp
      target firewalld_zone_target

      firewalld_default_zone = shell_out('firewall-cmd --get-default-zone').stdout.chomp
      if firewalld_default_zone == desired.zone
        default true
      else
        default false
      end
    else
      zone ''
    end
  else
    raise Chef::Exceptions::ValidationFailed, 'firewall-cmd is unavailable on this system, please validate that firewalld is installed'
  end
end

action :create do
  converge_if_changed :zone do
    cmd = "firewall-cmd --permanent --new-zone=#{new_resource.zone}; "
    cmd += 'firewall-cmd --reload'
    shell_out!(cmd)
  end
  converge_if_changed :target do
    cmd2 = "firewall-cmd --permanent --zone=#{new_resource.zone} --set-target=#{new_resource.target}; "
    cmd2 += 'firewall-cmd --reload'
    shell_out!(cmd2)
  end
  converge_if_changed :default do
    if new_resource.default
      cmd3a = "firewall-cmd --set-default-zone=#{new_resource.zone}; "
      cmd3a += 'firewall-cmd --reload'
      shell_out!(cmd3a)
    else
      log "Removing #{new_resource.zone} as the default zone, reverting to public zone as default"
      cmd3b = 'firewall-cmd --set-default-zone=public; '
      cmd3b += 'firewall-cmd --reload'
      shell_out!(cmd3b)
    end
  end
end

action :create_if_missing do
  converge_if_changed :zone do
    cmd = "firewall-cmd --permanent --new-zone=#{new_resource.zone}; "
    cmd += 'firewall-cmd --reload'
    shell_out!(cmd)
    unless new_resource.target == 'default'
      cmd2 = "firewall-cmd --permanent --zone=#{new_resource.zone} --set-target=#{new_resource.target}; "
      cmd2 += 'firewall-cmd --reload'
      shell_out!(cmd2)
    end
    if new_resource.default
      cmd3 = "firewall-cmd --set-default-zone=#{new_resource.zone}; "
      cmd3 += 'firewall-cmd --reload'
      shell_out!(cmd3)
    end
  end
end

action :delete do
  if current_resource.zone == new_resource.zone
    converge_by "Removing \"#{new_resource.zone}\" zone" do
      cmd3 = "firewall-cmd --permanent --delete-zone=#{new_resource.zone}; "
      cmd3 += 'firewall-cmd --reload'
      shell_out!(cmd3)
    end
  end
end
