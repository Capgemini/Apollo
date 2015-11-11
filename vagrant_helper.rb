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
