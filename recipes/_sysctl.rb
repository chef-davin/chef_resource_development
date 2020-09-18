grub_disabled_ipv6 = ::File.open('/etc/default/grub').grep(/ipv6.disable/)

node['cis_rhel_hardening']['sysctl'].each do |_key, values|
  sysctl_name = values[:name].to_s

  ipv6_disabled_by_grub = if (sysctl_name.include? 'ipv6') && !grub_disabled_ipv6.empty?
                            true
                          else
                            false
                          end
  sysctl values[:name] do
    value values[:value]
    ignore_failure true
    action :apply
    only_if { values[:enabled] == true }
    not_if { ipv6_disabled_by_grub == true }
  end

  delete_lines "Remove #{sysctl_name} from /etc/sysctl.conf" do
    path '/etc/sysctl.conf'
    pattern "^#{sysctl_name}.*"
    only_if { values[:enabled] == true }
  end

  if values[:control] && values[:enabled] == false
    inspec_waiver_file "Disable Control #{opt[:control]}" do
      file node['resource_development']['waivers']['file']
      control values[:control]
      action :add
    end
  elsif values[:control] && values[:enabled] == true
    inspec_waiver_file "Disable Control #{opt[:control]}" do
      file node['resource_development']['waivers']['file']
      control values[:control]
      action :remove
    end
  end
end
