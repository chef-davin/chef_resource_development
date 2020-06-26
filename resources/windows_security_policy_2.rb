# To learn more about Custom Resources, see https://docs.chef.io/custom_resources/
provides :windows_security_policy_2

# The valid POLICY_NAMES options found here
# https://github.com/ChrisAWalker/cSecurityOptions under 'AccountSettings'
POLICY_NAMES = %w{MaximumPasswordAge
                  MinimumPasswordAge
                  MinimumPasswordLength
                  PasswordComplexity
                  PasswordHistorySize
                  LockoutBadCount
                  ResetLockoutCount
                  LockoutDuration
                  RequireLogonToChangePassword
                  ForceLogoffWhenHourExpire
                  NewAdministratorName
                  NewGuestName
                  ClearTextPassword
                  LSAAnonymousNameLookup
                  EnableAdminAccount
                  EnableGuestAccount
                 }.freeze
description "Use the **windows_security_policy** resource to set a security policy on the Microsoft Windows platform."
introduced "16.0"

property :secoption, String,
  name_property: true,
  equal_to: POLICY_NAMES,
  description: "The name of the policy to be set on windows platform to maintain its security."

property :secvalue, String, required: true,
description: "Policy value to be set for policy name."

load_current_value do |desired|
  secopt_values = load_secopts_state
  output = powershell_out(secopt_values)
  if output.stdout.empty?
    current_value_does_not_exist!
  else
    state = Chef::JSONCompat.from_json(output.stdout)
  end
  secvalue state[desired.secoption.to_s]
end

def load_secopts_state
  <<-EOH
    C:\\Windows\\System32\\secedit /export /cfg $env:TEMP\\secopts_export.inf | Out-Null
    $secopts_data = (Get-Content $env:TEMP\\secopts_export.inf | Select-String -Pattern "^[CEFLMNPR].* =.*$" | Out-String)
    Remove-Item $env:TEMP\\secopts_export.inf -force
    $secopts_hash = ($secopts_data -Replace '"'| ConvertFrom-StringData)
    ([PSCustomObject]@{
      RequireLogonToChangePassword = $secopts_hash.RequireLogonToChangePassword
      PasswordComplexity = $secopts_hash.PasswordComplexity
      LSAAnonymousNameLookup = $secopts_hash.LSAAnonymousNameLookup
      EnableAdminAccount = $secopts_hash.EnableAdminAccount
      PasswordHistorySize = $secopts_hash.PasswordHistorySize
      MinimumPasswordLength = $secopts_hash.MinimumPasswordLength
      ResetLockoutCount = $secopts_hash.ResetLockoutCount
      MaximumPasswordAge = $secopts_hash.MaximumPasswordAge
      ClearTextPassword = $secopts_hash.ClearTextPassword
      NewAdministratorName = $secopts_hash.NewAdministratorName
      LockoutDuration = $secopts_hash.LockoutDuration
      EnableGuestAccount = $secopts_hash.EnableGuestAccount
      ForceLogoffWhenHourExpire = $secopts_hash.ForceLogoffWhenHourExpire
      MinimumPasswordAge = $secopts_hash.MinimumPasswordAge
      NewGuestName = $secopts_hash.NewGuestName
      LockoutBadCount = $secopts_hash.LockoutBadCount
    }) | ConvertTo-Json
  EOH
end

action :set do
  converge_if_changed :secvalue do
    security_option = new_resource.secoption
    security_value = new_resource.secvalue

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

    powershell_exec!(cmd)
  end
end
