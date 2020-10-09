provides :windows_audit_policy_2

WIN_AUDIT_SUBCATEGORIES = ['Account Lockout',
  'Application Generated',
  'Application Group Management',
  'Audit Policy Change',
  'Authentication Policy Change',
  'Authorization Policy Change',
  'Central Policy Staging',
  'Certification Services',
  'Computer Account Management',
  'Credential Validation',
  'DPAPI Activity',
  'Detailed Directory Service Replication',
  'Detailed File Share',
  'Directory Service Access',
  'Directory Service Changes',
  'Directory Service Replication',
  'Distribution Group Management',
  'File Share',
  'File System',
  'Filtering Platform Connection',
  'Filtering Platform Packet Drop',
  'Filtering Platform Policy Change',
  'Group Membership',
  'Handle Manipulation',
  'IPsec Driver',
  'IPsec Extended Mode',
  'IPsec Main Mode',
  'IPsec Quick Mode',
  'Kerberos Authentication Service',
  'Kerberos Service Ticket Operations',
  'Kernel Object',
  'Logoff',
  'Logon',
  'MPSSVC Rule-Level Policy Change',
  'Network Policy Server',
  'Non Sensitive Privilege Use',
  'Other Account Logon Events',
  'Other Account Management Events',
  'Other Logon/Logoff Events',
  'Other Object Access Events',
  'Other Policy Change Events',
  'Other Privilege Use Events',
  'Other System Events',
  'Plug and Play Events',
  'Process Creation',
  'Process Termination',
  'RPC Events',
  'Registry',
  'Removable Storage',
  'SAM',
  'Security Group Management',
  'Security State Change',
  'Security System Extension',
  'Sensitive Privilege Use',
  'Special Logon',
  'System Integrity',
  'Token Right Adjusted Events',
  'User / Device Claims',
  'User Account Management',
 ].freeze

property :subcategory, [String, Array],
  coerce: proc { |p| Array(p) },
  description: 'The audit policy subcategory, specified by GUID or name. Applied system-wide if no user is specified.',
  callbacks: { 'Subcategories entered should be actual advanced audit policy subcategories' => ->(n) { (Array(n) - WIN_AUDIT_SUBCATEGORIES).empty? } }

property :success, [true, false],
  description: 'Specify success auditing. By setting this property to true the resource will enable success for the category or sub category. Success is the default and is applied if neither success nor failure are specified.'

property :failure, [true, false],
  description: 'Specify failure auditing. By setting this property to true the resource will enable failure for the category or sub category. Success is the default and is applied if neither success nor failure are specified.'

property :include_user, String,
  description: 'The audit policy specified by the category or subcategory is applied per-user if specified. When a user is specified, include user. Include and exclude cannot be used at the same time.'

property :exclude_user, String,
  description: 'The audit policy specified by the category or subcategory is applied per-user if specified. When a user is specified, exclude user. Include and exclude cannot be used at the same time.'

property :crash_on_audit_fail, [true, false],
  description: 'Setting this audit policy option to true will cause the system to crash if the auditing system is unable to log events.'

property :full_privilege_auditing, [true, false],
  description: 'Setting this audit policy option to true will force the audit of all privilege changes except SeAuditPrivilege. Setting this property may cause the logs to fill up more quickly.'

property :audit_base_objects, [true, false],
  description: 'Setting this audit policy option to true will force the system to assign a System Access Control List to named objects to enable auditing of base objects such as mutexes.'

property :audit_base_directories, [true, false],
  description: 'Setting this audit policy option to true will force the system to assign a System Access Control List to named objects to enable auditing of container objects such as directories.'

action :set do
  unless new_resource.subcategory.nil?
    new_resource.subcategory.each do |subcategory|
      next if subcategory_configured?(subcategory, new_resource.success, new_resource.failure)

      s_val = new_resource.success ? 'enable' : 'disable'
      f_val = new_resource.failure ? 'enable' : 'disable'
      converge_by "Update Audit Policy for \"#{subcategory}\" to Success:#{s_val} and Failure:#{f_val}" do
        cmd = 'auditpol /set '
        cmd += "/user:\"#{new_resource.include_user}\" /include " if new_resource.include_user
        cmd += "/user:\"#{new_resource.exclude_user}\" /exclude " if new_resource.exclude_user
        cmd += "/subcategory:\"#{subcategory}\" /success:#{s_val} /failure:#{f_val}"
        powershell_exec!(cmd)
      end
    end
  end

  if !new_resource.crash_on_audit_fail.nil? && option_configured?('CrashOnAuditFail', new_resource.crash_on_audit_fail)
    val = new_resource.crash_on_audit_fail ? 'Enable' : 'Disable'
    converge_by "Configure Audit: CrashOnAuditFail to #{val}" do
      cmd = "auditpol /set /option:CrashOnAuditFail /value:#{val}"
      powershell_exec!(cmd)
    end
  end

  if !new_resource.full_privilege_auditing.nil? && option_configured?('FullPrivilegeAuditing', new_resource.full_privilege_auditing)
    val = new_resource.full_privilege_auditing ? 'Enable' : 'Disable'
    converge_by "Configure Audit: FullPrivilegeAuditing to #{val}" do
      cmd = "auditpol /set /option:FullPrivilegeAuditing /value:#{val}"
      powershell_exec!(cmd)
    end
  end

  if !new_resource.audit_base_directories.nil? && option_configured?('AuditBaseDirectories', new_resource.audit_base_directories)
    val = new_resource.audit_base_directories ? 'Enable' : 'Disable'
    converge_by "Configure Audit: AuditBaseDirectories to #{val}" do
      cmd = "auditpol /set /option:AuditBaseDirectories /value:#{val}"
      powershell_exec!(cmd)
    end
  end

  if !new_resource.audit_base_objects.nil? && option_configured?('AuditBaseObjects', new_resource.audit_base_objects)
    val = new_resource.audit_base_objects ? 'Enable' : 'Disable'
    converge_by "Configure Audit: AuditBaseObjects to #{val}" do
      cmd = "auditpol /set /option:AuditBaseObjects /value:#{val}"
      powershell_exec!(cmd)
    end
  end
end

action_class do
  def subcategory_configured?(sub_cat, success_value, failure_value)
    setting = if success_value && failure_value
                'Success and Failure$'
              elsif success_value && !failure_value
                'Success$'
              elsif !success_value && failure_value
                "#{sub_cat} \\s+ Failure$"
              else
                'No Auditing'
              end
    powershell_exec!(<<-CODE).result
      $auditpol_config = auditpol /get /subcategory:"#{sub_cat}"
      if ($auditpol_config | Select-String "#{setting}") { return $true } else { return $false }
    CODE
  end

  def option_configured?(option_name, option_setting)
    setting = option_setting ? 'Enabled$' : 'Disabled$'
    powershell_exec!(<<-CODE).result
      $auditpol_config = auditpol /get /option:"#{option_name}""
      if ($auditpol_config | Select-String "#{setting}") { return $true } else { return $false }
    CODE
  end
end