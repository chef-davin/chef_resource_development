default['resource_development']['waivers']['file'] = '/etc/chef/waivers.yaml'
default['resource_development']['waivers']['default_controls'] = [{ control: 'Example_Control_01', expiration: '2025-01-01', run_test: false, justification: 'This is just an example control waiver' }]
default['resource_development']['waivers']['additional_controls'] = []
default['resource_development']['waivers']['removed_waivers'] = [{ control: 'Example_Control_02' }]
default['resource_development']['waivers']['additional_removed'] = []
