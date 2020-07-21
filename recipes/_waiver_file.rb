waiver_file = node['hpe_base_linux']['waivers']['file']
default_waivers = node['hpe_base_linux']['waivers']['default_controls']
additional_waivers = ['hpe_base_linux']['waivers']['additional_controls']
waiver_removes = node['hpe_base_linux']['waivers']['removed_waivers']
additional_removals = node['hpe_base_linux']['waivers']['additional_removed']

default_waivers.each do |waiver|
  hpe_inspec_waiver_file waiver[:control] do
    file waiver_file
    expiration waiver[:expiration] unless waiver[:expiration].nil? || !waiver.key?(:expiration)
    run_test waiver[:run_test] unless waiver[:run_test].nil? || !waiver.key?(:run_test)
    justification waiver[:justification]
    action :add
  end
end

unless waiver_removes.empty?
  waiver_removes.each do |waiver|
    hpe_inspec_waiver_file waiver[:control] do
      file waiver_file
      action :remove
    end
  end
end

unless additional_waivers.empty?
  additional_waivers.each do |waiver|
    hpe_inspec_waiver_file waiver[:control] do
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
    hpe_inspec_waiver_file waiver[:control] do
      file waiver_file
      action :remove
    end
  end
end
