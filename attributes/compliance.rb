default['audit']['compliance_phase'] = true

# default['audit']['waiver_file'] = 'C:\chef\inspec_waiver_file.yml'

default['audit']['fetcher'] = node['policy_group'] == 'local' ? 'chef-automate' : 'chef-server'

default['audit']['reporter'] = node['policy_group'] == 'local' ? 'chef-automate' : 'chef-server-automate'

default['audit']['profiles']['DevSec Windows Security Baseline'] = { compliance: 'tdarwin/windows-baseline' }
