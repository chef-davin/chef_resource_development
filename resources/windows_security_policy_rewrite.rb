unified_mode true

provides :windows_security_policy

# The valid policy_names options found here
# https://github.com/ChrisAWalker/cSecurityOptions under 'AccountSettings'
policy_names = %w{LockoutDuration
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
                 }
description "Use the **windows_security_policy** resource to set a security policy on the Microsoft Windows platform."
introduced "16.0"

property :secoption, String, name_property: true, required: true, equal_to: policy_names,
description: "The name of the policy to be set on windows platform to maintain its security."

property :secvalue, String, required: true,
description: "Policy value to be set for policy name."

load_current_value do |desired|
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
    }) | ConvertTo-Json
  CODE
  output = powershell_out(powershell_code)
  current_value_does_not_exist! if output.stdout.empty?
  state = Chef::JSONCompat.from_json(output.stdout)

  if desired.secoption == "ResetLockoutCount" || desired.secoption == "LockoutDuration"
    if state["LockoutBadCount"] == "0"
      raise Chef::Exceptions::ValidationFailed.new "#{desired.secoption} cannot be set unless the \"LockoutBadCount\" security policy has been set to a non-zero value"
    else
      secvalue state[desired.secoption.to_s]
    end
  else
    secvalue state[desired.secoption.to_s]
  end
end

action :set do
  converge_if_changed :secvalue do
    security_option = new_resource.secoption
    security_value = new_resource.secvalue

    unless security_option == 'NewAdministratorName' || security_option == 'NewGuestName'
      security_value = new_resource.secvalue.to_i
    end

    cmd = <<-EOH
      $security_option = "#{security_option}"
      C:\\Windows\\System32\\secedit /export /cfg $env:TEMP\\#{security_option}_Export.inf
      if ( ($security_option -match "NewGuestName") -Or ($security_option -match "NewAdministratorName") )
        {
          $#{security_option}_Remediation = (Get-Content $env:TEMP\\#{security_option}_Export.inf) | Foreach-Object { $_ -replace '#{security_option}\\s*=\\s*\\"\\w*\\"', '#{security_option} = "#{security_value}"' } | Set-Content $env:TEMP\\#{security_option}_Export.inf
          C:\\Windows\\System32\\secedit /configure /db $env:windir\\security\\new.sdb /cfg $env:TEMP\\#{security_option}_Export.inf /areas SECURITYPOLICY
        }
      else
        {
          $#{security_option}_Remediation = (Get-Content $env:TEMP\\#{security_option}_Export.inf) | Foreach-Object { $_ -replace "#{security_option}\\s*=\\s*\\d*", "#{security_option} = #{security_value}" } | Set-Content $env:TEMP\\#{security_option}_Export.inf
          C:\\Windows\\System32\\secedit /configure /db $env:windir\\security\\new.sdb /cfg $env:TEMP\\#{security_option}_Export.inf /areas SECURITYPOLICY
        }
      Remove-Item $env:TEMP\\#{security_option}_Export.inf -force
    EOH

    powershell_out!(cmd)
  end
end