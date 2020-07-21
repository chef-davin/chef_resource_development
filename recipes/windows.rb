windows_task 'chef-client' do
  cwd 'C:\\opscode\\chef\\bin'
  command 'chef-client -L C:\\chef\\log\\client.log'
  description 'Runs the chef-client binary. Configured by the windows_task resource rather than the chef_client_scheduled_task'
  frequency :hourly
  random_delay 600
  action :create
end

# windows_task "chef-client-daily" do
#   cwd "C:\\opscode\\chef\\bin"
#   command "chef-client -L C:\\chef\\log\\daily_client.log"
#   description "Runs the chef-client at roughly 3am every day."
#   frequency :daily
#   start_time "03:00"
#   random_delay 600
#   action :create
# end

windows_security_policy_2 'EnableGuestAccount' do
  secvalue '0'
  action :set
end

windows_security_policy_2 'NewGuestName' do
  secvalue 'NeverBeAGuest'
  action :set
end

windows_firewall_profile 'Configure and Enable Windows Firewall Domain Profile' do
  profile 'Domain'
  default_inbound_action 'Block'
  default_outbound_action 'Allow'
  allow_inbound_rules true
  allow_local_firewall_rules true
  allow_local_ipsec_rules true
  allow_unicast_response false
  display_notification false
  action :enable
end

windows_firewall_profile 'Public' do
  default_inbound_action 'Block'
  default_outbound_action 'Allow'
  allow_inbound_rules true
  allow_local_firewall_rules false
  allow_local_ipsec_rules false
  allow_unicast_response false
  display_notification false
  action :enable
end

windows_firewall_profile 'Private' do
  default_inbound_action 'Block'
  default_outbound_action 'Allow'
  allow_inbound_rules true
  allow_local_firewall_rules true
  allow_local_ipsec_rules true
  allow_unicast_response false
  display_notification false
  action :enable
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