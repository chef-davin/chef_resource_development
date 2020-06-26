#
# Cookbook:: resource_development
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
# windows_user_privilege_2 "SeDenyNetworkLogonRight" do
#   privilege ""
#   action :clear
# end

# windows_security_policy_2 "EnableGuestAccount" do
#   secvalue "0"
#   action :set
# end

# windows_security_policy_2 "NewGuestName" do
#   secvalue "NotInUse"
#   action :set
# end
