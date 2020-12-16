require 'tempfile'
unified_mode true

provides :windows_security_policy

# The valid policy_names options found here
# https://github.com/ChrisAWalker/cSecurityOptions under 'AccountSettings'
policy_names = %w(LockoutDuration
                  MaximumPasswordAge
                  MinimumPasswordAge
                  MinimumPasswordLength
                  PasswordComplexity
                  PasswordHistorySize
                  LockoutBadCount
                  ResetLockoutCount
                  RequireLogonToChangePassword
                  ForceLogoffWhenHourExpire
                  NewAdministratorName
                  NewGuestName
                  ClearTextPassword
                  LSAAnonymousNameLookup
                  EnableAdminAccount
                  EnableGuestAccount
                 )
description 'Use the **windows_security_policy** resource to set a security policy on the Microsoft Windows platform.'
introduced '16.0'

property :secoption, String, name_property: true, equal_to: policy_names,
description: 'The name of the policy to be set on windows platform to maintain its security.'

property :secvalue, String, required: true,
description: 'Policy value to be set for policy name.'

load_current_value do |desired|
  current_state = load_security_options

  if desired.secoption == 'ResetLockoutCount'
    if desired.secvalue.to_i > 30
      raise Chef::Exceptions::ValidationFailed, "The \"ResetLockoutCount\" value cannot be greater than 30 minutes"
    end
  end
  if desired.secoption == 'ResetLockoutCount' || desired.secoption == 'LockoutDuration'
    if current_state['LockoutBadCount'] == '0'
      raise Chef::Exceptions::ValidationFailed, "#{desired.secoption} cannot be set unless the \"LockoutBadCount\" security policy has been set to a non-zero value"
    else
      secvalue current_state[desired.secoption.to_s]
    end
  else
    secvalue current_state[desired.secoption.to_s]
  end
end

action :set do
  converge_if_changed :secvalue do
    security_option = new_resource.secoption
    security_value = new_resource.secvalue

    file = Tempfile.new(["#{security_option}", '.inf'])
    case security_option
    when 'LockoutBadCount'
      cmd = "net accounts /LockoutThreshold:#{security_value}"
    when 'ResetLockoutCount'
      cmd = "net accounts /LockoutWindow:#{security_value}"
    when 'LockoutDuration'
      cmd = "net accounts /LockoutDuration:#{security_value}"
    when 'NewAdministratorName', 'NewGuestName'
      policy_line = "#{security_option} = \"#{security_value}\""
      file.write("[Unicode]\r\nUnicode=yes\r\n[System Access]\r\n#{policy_line}\r\n[Version]\r\nsignature=\"$CHICAGO$\"\r\nRevision=1\r\n")
      file.close
      file_path = file.path.gsub('/', '\\')
      cmd = "C:\\Windows\\System32\\secedit /configure /db C:\\windows\\security\\new.sdb /cfg #{file_path} /areas SECURITYPOLICY"
    else
      policy_line = "#{security_option} = #{security_value}"
      file.write("[Unicode]\r\nUnicode=yes\r\n[System Access]\r\n#{policy_line}\r\n[Version]\r\nsignature=\"$CHICAGO$\"\r\nRevision=1\r\n")
      file.close
      file_path = file.path.gsub('/', '\\')
      cmd = "C:\\Windows\\System32\\secedit /configure /db C:\\windows\\security\\new.sdb /cfg #{file_path} /areas SECURITYPOLICY"
    end
    shell_out!(cmd)
    file.unlink
  end
end

def load_security_options
  powershell_code = <<-CODE
    C:\\Windows\\System32\\secedit /export /cfg $env:TEMP\\secopts_export.inf | Out-Null
    # cspell:disable-next-line
    $security_options_data = (Get-Content $env:TEMP\\secopts_export.inf | Select-String -Pattern "^[CEFLMNPR].* =.*$" | Out-String)
    Remove-Item $env:TEMP\\secopts_export.inf -force
    $security_options_hash = ($security_options_data -Replace '"'| ConvertFrom-StringData)
    ([PSCustomObject]@{
      RequireLogonToChangePassword = $security_options_hash.RequireLogonToChangePassword
      PasswordComplexity = $security_options_hash.PasswordComplexity
      LSAAnonymousNameLookup = $security_options_hash.LSAAnonymousNameLookup
      EnableAdminAccount = $security_options_hash.EnableAdminAccount
      PasswordHistorySize = $security_options_hash.PasswordHistorySize
      MinimumPasswordLength = $security_options_hash.MinimumPasswordLength
      ResetLockoutCount = $security_options_hash.ResetLockoutCount
      MaximumPasswordAge = $security_options_hash.MaximumPasswordAge
      ClearTextPassword = $security_options_hash.ClearTextPassword
      NewAdministratorName = $security_options_hash.NewAdministratorName
      LockoutDuration = $security_options_hash.LockoutDuration
      EnableGuestAccount = $security_options_hash.EnableGuestAccount
      ForceLogoffWhenHourExpire = $security_options_hash.ForceLogoffWhenHourExpire
      MinimumPasswordAge = $security_options_hash.MinimumPasswordAge
      NewGuestName = $security_options_hash.NewGuestName
      LockoutBadCount = $security_options_hash.LockoutBadCount
    })
  CODE
  powershell_exec(powershell_code).result
end
