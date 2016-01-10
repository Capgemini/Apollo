# Gets environment variables with APOLLO_ prefix
# We merge those variables with ansible.extra_vars in Vagrantfile
def get_apollo_variables(env)
	apollo_env_vars = {}
	apollo_prefix = /^APOLLO_/

	env.each { |key, value|
		if key.match(apollo_prefix)
			key_name = key.gsub(apollo_prefix, '').to_sym
			apollo_env_vars[key_name] = value
		end
	}

	return apollo_env_vars
end

# Automatically replace the discovery token on 'vagrant up'
def etcd_discovery_token(num_instances)
  # Used to fetch a new discovery token for a cluster of size num_instances
  $new_discovery_url="https://discovery.etcd.io/new?size=#{num_instances}"

  if File.exists?('user-data') && ARGV[0].eql?('up')
    require 'open-uri'
    require 'yaml'

    token = open($new_discovery_url).read

    data = YAML.load(IO.readlines('user-data')[1..-1].join)

    if data.key? 'coreos' and data['coreos'].key? 'etcd'
      data['coreos']['etcd']['discovery'] = token
    end

    if data.key? 'coreos' and data['coreos'].key? 'etcd2'
      data['coreos']['etcd2']['discovery'] = token
    end

    # Fix for YAML.load() converting reboot-strategy from 'off' to `false`
    if data.key? 'coreos' and data['coreos'].key? 'update' and data['coreos']['update'].key? 'reboot-strategy'
      if data['coreos']['update']['reboot-strategy'] == false
        data['coreos']['update']['reboot-strategy'] = 'off'
      end
    end

    yaml = YAML.dump(data)
    File.open('user-data', 'w') { |file| file.write("#cloud-config\n\n#{yaml}") }
  end
end
