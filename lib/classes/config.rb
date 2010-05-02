require 'yaml'

module Picombo
	# == Config Class
	#
	# Handles retreiving of key value storage items
	#
	# Picombo uses config items internally to keep track of common and long term configuration values. These files are stored in yaml files.
	#
	# === Overview
	# There are several built in config file types:
	#  * config.yaml
	#  * datamapper.yaml
	#  * cache.yaml
	#  * log.yaml
	#  * mimes.yaml
	#
	# The only file required to be in your application directory is config.yaml. The rest of the files are defined in the system location.
	# You can change/overwrite the system values by creating the file in your application directory and specifying your application values there.
	# Please refer to the source system files for examples.
	#
	# === Usage
	# To call config values, use the Picombo::Config.get method. The first parameter is the path of your config value, using dot notation. With dot notation, the first part is the filename, and everything after that is the path inside the file.
	#
	# ==== Example
	# For the following file (datamapper.yaml):
	#
	# 	default:
	# 	 driver: mysql
	# 	 host: localhost
	# 	 database: picom_db
	# 	 username: picom_u
	# 	 password: picom_p
	#
	# You can get the database config value like:
	#
	# Picombo::Config.get('datamapper.default.database')
	class Config
		include Enumerable

		# Internal cache.
		@@cache = {}

		# Loads configuration files by name
		def self.load(name)
			# Look for this config item in the cache
			if @@cache.has_key?(name)
				return @@cache[name]
			end

			configuration, files = {}, Picombo::Core.find_file('config', name, false, 'yaml')

			files.each do |file|
				configuration.merge! YAML::load_file(file)
			end

			# Set the internal cache
			@@cache[name] = configuration

			configuration
			rescue Errno::ENOENT => e
			# A config file couldn't be loaded...
		end

		# Used for dynamic config setting. Not implimented yet
		def self.set(key, value)
		end

		# Retrieves a config item in dot notation
		def self.get(key, required = true)
			# get the group name from the key
			key = key.split('.')
			group = key.shift

			value = key_string(load(group), key.join('.'))

			raise "Config key '"+key.join('.')+"' not found!!" if required && value.nil?

			value
		end

		# Clears the internal cache for a config file(s)
		def self.clear(group)
			@@cache.delete(group)
		end

		# Allows searching an hash by dot seperated strings
		def self.key_string(hash, keys)
			return false if ! hash.is_a? Hash

			keys = keys.split('.')

			until keys.length == 0
				key = keys.shift

				if hash.has_key? key
					if hash[key].is_a? Hash and ! keys.empty?
						hash = hash[key]
					else
						return hash[key]
					end
				else
					break
				end
			end

			nil
		end

		#
		# Define an each method, required for Enumerable.
		#
		def self.each(file)

		end
	end
end