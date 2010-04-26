module Picombo
	# == Cache Class
	#
	# The cache class allows you to serialize ruby objects,
	# store them in a backend system, and retreive them later.
	# 
	# Caching can be useful for methods that take a long time to run,
	# or complex database queries that cannot be made quicker.
	#
	# === Usage
	#
	# To set a cache item, use the set method:
	# 	Picombo::Cache.new.set(:test, '<h1>It Works!</h1><p>This is a test.</p>')
	# You can also pass a hash into the first parameter to set multiple items
	#
	# To retreive a cache item, use the get method:
	# 	html = Picombo::Cache.new.get(:test)
	# 	# html will contain '<h1>It Works!</h1><p>This is a test.</p>'
	#
	# To delete an existing cache item, use the delete method
	# 	Picombo::Cache.new.delete(:test)
	#
	# === Drivers
	#
	# The cache class supports drivers, which will allow you to use different backend
	# systems to store your cache items. Right now only a file driver is available.
	# You can write your own cache drivers to behave how you want as well.
	#
	# By default the cache driver will use the "default" group in your config file: cache.yaml
	# You can specify multiple groups as well.
	#
	# ==== Usage
	#
	# To call the cache driver with an alternate group, just pass that group name into the new method
	# 	Picombo::Cache.new('my_other_group')
	#
	# To do this, you need to define the 'my_other_group' in your config file
	#
	# === Lifetimes
	#
	# The cache class supports lifetimes, which will automatically expire cache items after the
	# specified time period. These are specifies in seconds from the current time. When you use the
	# set method, you can set a specific lifetime with the third parameter.
	# The default is located in the config file group
	class Cache

		@@driver = nil
		@@config = nil
		@@group = nil

		# Set up the driver
		def initialize(group = nil)
			group = 'default' if group == nil
			@@group = group
			@@config = Picombo::Config.get('cache.'+group)
			driver_name = 'Cache_'+@@config['driver'].capitalize!
			@@driver = Picombo::const_get(driver_name).new(@@config)
		end

		# Sets a cache item
		def set(key, value = nil, lifetime = nil)
			lifetime = Picombo::Config.get('cache.'+@@group+'.lifetime').to_i if lifetime == nil
			unless key.is_a? Hash
				key = {key => value}
			end

			@@driver.set(key, lifetime)
		end

		# Retreives a cache item
		def get(key)
			@@driver.get(key.to_s, (key.is_a? Array) ? true : false)
		end

		# Deletes a cache item
		def delete(keys)
			unless key.is_a? Array
				key = [key]
			end

			@@driver.delete(keys)
		end

		# Deletes all the cache items
		def delete_all
			@@driver.delete_all
		end
	end
end