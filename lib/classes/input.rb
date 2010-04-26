module Picombo
	# Provides access and XSS filtering to GET and POST input variables
	#
	# == Using Input
	# * To fetch get variables, simple use Picombo::Input.instance().get(get_key)
	# * To fetch post variables, simple use Picombo::Input.instance().post(post)
	#
	# * To return the entire input hash, omit the key
	# * If the key is not found, the default parameter is returned, by default nil
	#
	# === XSS Filtering
	#
	# in the main config file, there is an xss_clean option. If you set this to true,
	# all GET and POST variables will be scanned and cleaned of script data. You can manually
	# filter strings by using:
	# 	Picombo::Input.instance.xss_clean(str)
	class Input
		include Singleton

		# Sets the input request
		def set_request(req)
			@req = req

			if Picombo::Config.get('config.xss_clean')
				@req.GET().each do |key, value|
					Picombo::Log.write(:debug, 'Cleaning GET key: '+key)
					@req.GET()[key] = Picombo::Security.xss_clean(value, Picombo::Config.get('config.xss_clean'))
				end
				@req.POST().each do |key, value|
					Picombo::Log.write(:debug, 'Cleaning POST key: '+key)
					@req.POST()[key] = Picombo::Security.xss_clean(value, Picombo::Config.get('config.xss_clean'))
				end
			end
			Picombo::Log.write(:debug, 'Input Library initialized')
		end

		# Retrieves a GET item by key. If the key doesn't exist, return default
		# Optionaly returns the entire GET hash if key is nil
		def get(key = nil, default = nil)
			return @req.GET() if key.nil?

			get = @req.GET()
			return get[key] if get.has_key?(key)

			default
		end

		# Retrieves a POST item by key. If the key doesn't exist, return default
		# Optionaly returns the entire POST hash if key is nil
		def post(key = nil, default = nil)
			return @req.POST() if key.nil?

			post = @req.POST()
			return post[key] if post.has_key?(key)

			default
		end
	end
end