module Picombo
	# Provides access and XSS filtering to GET and POST input variables
	#
	# == Using Input
	# * To fetch get variables, simple use Picombo::Input.instance().get(get_key)
	# * To fetch post variables, simple use Picombo::Input.instance().post(post)
	#
	# * To return the entire input hash, omit the key
	# * If the key is not found, the default parameter is returned, by default nil
	class Input
		include Singleton

		# Sets the input request
		def set_request(req)
			@req = req

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

		def query_string(hash)
			temp = []

			hash.each do |key, value|
				temp << key+'='+value
			end

			temp.join('&')
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