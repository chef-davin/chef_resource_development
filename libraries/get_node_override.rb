require 'json'
module ResourceDevelopment
  module AttributeOverride
    def find_value(hash, keys)
      keys.inject(hash.dup) do |prev, key|
        prev && prev[key] ? prev[key] : nil
      end
    end

    def get_attribute(*args)
      overrides_file = if windows?
                         'C:\cis_overrides.json'
                       else
                         '/root/cis_overrides.json'
                       end

      first_key = args[0]
      all_sub_keys = args.shift
      default_attribute = find_value(node[first_key], all_sub_keys)

      if File.exist?(overrides_file)
        all_override_attributes = JSON.load(::File.new(overrides_file, 'r'))
        override_attribute = find_value(all_override_attributes['override'], all_sub_keys)
        if override_attribute.nil?
          default_attribute
        else
          override_attribute
        end
      else
        default_attribute
      end
    end
  end
end

Chef::Resource.include ::ResourceDevelopment::AttributeOverride
Chef::DSL::Recipe.include ::ResourceDevelopment::AttributeOverride
Chef::Node.include ::ResourceDevelopment::AttributeOverride
