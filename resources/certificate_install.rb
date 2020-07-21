provides :hpe_certificate_install
resource_name :hpe_certificate_install
unified_mode true

description 'Use the **hpe_certificate_install** resource to add certificates to the system cacert'

property :certificate, String,
  name_property: true,
  description: 'The certificate name'

property :source, String,
  required: true,
  description: 'Where the template lives'

property :cookbook, String,
  description: 'If the certificate template source is in a separate cookbook, this will specify the cookbook'

property :add_to_chef, [true, false],
  default: true,
  description: 'Add the trusted certs to /etc/chef/trusted_certs so that chef resources will also utilize the certificates'

action :add do
  package 'Install ca-certificates' do
    package_name 'ca-certificates'
    action :install
  end

  converge_by 'Enable CA Trust User Parameters' do
    command = '/bin/update-ca-trust force-enable'
    shell_out!(command)
  end

  cookbook_file "/etc/pki/ca-trust/source/anchors/#{new_resource.certificate}" do
    source new_resource.source
    cookbook new_resource.cookbook unless new_resource.cookbook.nil?
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  if new_resource.add_to_chef == true
    cookbook_file "/etc/chef/trusted_certs/#{new_resource.certificate}" do
      source new_resource.source
      cookbook new_resource.cookbook unless new_resource.cookbook.nil?
      owner 'root'
      group 'root'
      mode '0755'
      action :create
    end
  end

  converge_by "Enable CA Trust Certificate #{new_resource.certificate}" do
    command = '/bin/update-ca-trust extract'
    shell_out!(command)
  end
end
