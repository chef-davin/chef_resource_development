waiver_file = node['resource_development']['waivers']['file']
default_waivers = node['resource_development']['waivers']['default_controls']
additional_waivers = ['resource_development']['waivers']['additional_controls']
waiver_removes = node['resource_development']['waivers']['removed_waivers']
additional_removals = node['resource_development']['waivers']['additional_removed']

default_waivers.each do |waiver|
  inspec_waiver_file waiver[:control] do
    file waiver_file
    expiration waiver[:expiration] unless waiver[:expiration].nil? || !waiver.key?(:expiration)
    run_test waiver[:run_test] unless waiver[:run_test].nil? || !waiver.key?(:run_test)
    justification waiver[:justification]
    action :add
  end
end

unless waiver_removes.empty?
  waiver_removes.each do |waiver|
    inspec_waiver_file waiver[:control] do
      file waiver_file
      action :remove
    end
  end
end

unless additional_waivers.empty?
  additional_waivers.each do |waiver|
    inspec_waiver_file waiver[:control] do
      file waiver_file
      expiration waiver[:expiration] unless waiver[:expiration].nil? || !waiver.key?(:expiration)
      run_test waiver[:run_test] unless waiver[:run_test].nil? || !waiver.key?(:run_test)
      justification waiver[:justification]
      action :add
    end
  end
end

unless additional_removals.empty?
  additional_removals.each do |waiver|
    inspec_waiver_file waiver[:control] do
      file waiver_file
      action :remove
    end
  end
end
