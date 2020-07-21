#
# Cookbook:: resource_development
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
# windows_user_privilege_2 "SeDenyNetworkLogonRight" do
#   privilege ""
#   action :clear
# end
include_recipe 'audit::default'

if windows?
  include_recipe 'resource_development::windows'
else
  include_recipe 'resource_development::linux'
end
