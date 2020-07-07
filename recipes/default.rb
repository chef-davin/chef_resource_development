#
# Cookbook:: resource_development
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
# windows_user_privilege_2 "SeDenyNetworkLogonRight" do
#   privilege ""
#   action :clear
# end
include_recipe "audit::default"

# windows_task "chef-client-hourly" do
#   cwd "C:\\opscode\\chef\\bin"
#   command "chef-client -L C:\\chef\\log\\hourly_client.log"
#   description "Runs the chef-client binary. Configured by the windows_task resource rather than the chef_client_scheduled_task"
#   frequency :hourly
#   random_delay 600
#   action :create
# end

# windows_task "chef-client-daily" do
#   cwd "C:\\opscode\\chef\\bin"
#   command "chef-client -L C:\\chef\\log\\daily_client.log"
#   description "Runs the chef-client at roughly 3am every day."
#   frequency :daily
#   start_time "03:00"
#   random_delay 600
#   action :create
# end

windows_security_policy_2 "EnableGuestAccount" do
  secvalue "0"
  action :set
end

windows_security_policy_2 "NewGuestName" do
  secvalue "NeverBeAGuest"
  action :set
end

# inspec_waiver_file "cis-access-cred-manager-2.2.1" do
#   file 'C:\\chef\\inspec_waiver_file.yml'
#   justification "Because I want to waive this BS"
#   action :add
# end

# inspec_waiver_file "cis-act-as-os-2.2.3" do
#   file 'C:\\chef\\inspec_waiver_file.yml'
#   expiration "2022-07-01"
#   justification "This control should be waived for a couple years at least"
#   action :add
# end

# inspec_waiver_file "powershell-script-blocklogging" do
#   file 'C:\\chef\\inspec_waiver_file.yml'
#   justification "This control should be waived for a while"
#   action :add
# end

# inspec_waiver_file "disable-windows-store" do
#   file 'C:\\chef\\inspec_waiver_file.yml'
#   action :remove
# end

# inspec_waiver_file "microsoft-online-accounts" do
#   file 'C:\\inspec_waiver_file.yml'
#   action :remove
# end
