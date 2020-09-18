#
# Cookbook:: services
# Recipe:: daemons
#
# Copyright:: 2019, The Authors, All Rights Reserved.
services = node['cis_rhel_hardening']['services']

services.each do |svc_name, svc_values|
  svc = svc_name
  unless svc_values[:manage] == false
    service svc do
      action svc_values[:action]
      only_if "/sbin/chkconfig --list | grep #{svc}" if svc_values[:type] == 'xinetd'
      only_if "/usr/bin/systemctl | grep #{svc}" if svc_values[:type] == 'systemd'
      ignore_failure
    end
  end

  if svc_values[:control] && svc_values[:manage] == false
    inspec_waiver_file "Waive InSpec control for #{svc}" do
      file node['resource_development']['waivers']['file']
      control svc_values[:control]
      justification svc_values[:justification]
      action :add
    end
  elsif svc_values[:control] && svc_values[:manage] == true
    inspec_waiver_file "Ensure InSpec control for #{svc} is not waived" do
      file node['resource_development']['waivers']['file']
      control svc_values[:control]
      action :remove
    end
  end
end

log 'message' do
  level :info
end
