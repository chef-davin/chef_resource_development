# windows_audit_policy_2 'Update some audit policies' do
#   subcategory ['Application Generated', 'Application Group Management', 'Audit Policy Change', 'Authentication Policy Change', 'Authorization Policy Change', 'Central Policy Staging', 'Certification Services', 'Computer Account Management', 'Credential Validation', 'DPAPI Activity', 'Detailed File Share', 'Directory Service Access', 'Directory Service Changes', 'Directory Service Replication', 'Distribution Group Management', 'File Share', 'File System', 'Filtering Platform Connection', 'Filtering Platform Packet Drop', 'Filtering Platform Policy Change', 'Group Membership', 'Handle Manipulation', 'IPsec Driver', 'IPsec Extended Mode', 'IPsec Main Mode', 'IPsec Quick Mode', 'Kerberos Authentication Service', 'Kerberos Service Ticket Operations', 'Kernel Object', 'Logoff', 'Logon', 'MPSSVC Rule-Level Policy Change', 'Network Policy Server', 'Non Sensitive Privilege Use', 'Other Account Logon Events', 'Other Account Management Events', 'Other Logon/Logoff Events', 'Other Object Access Events', 'Other Policy Change Events', 'Other Privilege Use Events', 'Other System Events', 'Plug and Play Events', 'Process Creation', 'Process Termination', 'RPC Events', 'Registry', 'Removable Storage', 'SAM', 'Security Group Management', 'Security State Change', 'Security System Extension', 'Sensitive Privilege Use', 'Special Logon', 'System Integrity', 'Token Right Adjusted Events', 'User / Device Claims', 'User Account Management', 'Account Lockout']
#   success true
#   failure false
# end

# windows_firewall_profile 'Configure and Enable Windows Firewall Domain Profile' do
#   profile 'Domain'
#   default_inbound_action 'Block'
#   default_outbound_action 'Allow'
#   allow_inbound_rules true
#   allow_local_firewall_rules true
#   allow_local_ipsec_rules true
#   allow_unicast_response false
#   display_notification false
#   action :enable
# end

# windows_firewall_profile 'Public' do
#   default_inbound_action 'Block'
#   default_outbound_action 'Allow'
#   allow_inbound_rules true
#   allow_local_firewall_rules false
#   allow_local_ipsec_rules false
#   allow_unicast_response false
#   display_notification false
#   action :enable
# end

# windows_firewall_profile 'Private' do
#   default_inbound_action 'Block'
#   default_outbound_action 'Allow'
#   allow_inbound_rules true
#   allow_local_firewall_rules true
#   allow_local_ipsec_rules true
#   allow_unicast_response false
#   display_notification false
#   action :enable
# end

# file 'C:\\chef\\inspec_waiver_file.yml' do
#   content '---'
#   action :create
# end

inspec_waiver_file 'cis-access-cred-manager-2.2.1' do
  file 'C:\\chef\\inspec_waiver_file.yml'
  justification 'Because I want to waive this BS'
  action :add
end

inspec_waiver_file 'cis-act-as-os-2.2.3' do
  file 'C:\\chef\\inspec_waiver_file.yml'
  expiration '2022-02-28'
  justification 'This control should be waived for a couple years at least'
  action :add
end

inspec_waiver_file 'powershell-script-blocklogging' do
  file 'C:\\chef\\inspec_waiver_file.yml'
  justification 'This control should be waived for a while'
  action :add
end

inspec_waiver_file 'disable-windows-store' do
  file 'C:\\chef\\inspec_waiver_file.yml'
  action :remove
end

inspec_waiver_file 'microsoft-online-accounts' do
  file 'C:\\chef\\inspec_waiver_file.yml'
  action :remove
end

# windows_security_policy 'NewGuestName' do
#   secvalue 'dusttodust'
#   action :set
# end

# windows_security_policy 'EnableGuestAccount' do
#   secvalue '1'
#   action :set
# end

# windows_security_policy 'MaximumPasswordAge' do
#   secvalue '252'
#   action :set
# end

# windows_security_policy 'LockoutBadCount' do
#   secvalue '5'
#   action :set
# end

# windows_security_policy 'LockoutDuration' do
#   secvalue '30'
#   action :set
# end
