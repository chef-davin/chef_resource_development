default['hpe_base_linux']['waivers']['file'] = '/etc/chef/waivers.yaml'
default['hpe_base_linux']['waivers']['default_controls'] = [{ control: 'Example_Control_01', expiration: '2025-01-01', run_test: false, justification: 'This is just an example control waiver' }]
default['hpe_base_linux']['waivers']['additional_controls'] = []
default['hpe_base_linux']['waivers']['removed_waivers'] = [{ control: 'Example_Control_02' }]
default['hpe_base_linux']['waivers']['additional_removed'] = []
