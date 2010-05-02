module Picombo
	# == Session handling class
	#
	# In essense, a proxy to the rack session handling methods.
	#
	# == Example usage
	# Writing cookie values
	# 	Picombo::Session.set(:sample, 'this is the content of the session var')
	#
	# Getting cookie values
	# 	Picombo::Session.get(:sample)
	class Session
		include Singleton

		# Initializes the request for cookies
		def init(req)
			@@req = req
		end

		# Retrieves a session item defined by key, returns default if item doesn't exist
		# You can retreive the entire session by omiting the key paramter
		def get(key = nil, default = nil)
			return @@req.session if key.nil?

			result = Picombo::Config.key_string(@@req.session, key)

			return result.nil? ? default : result
		end

		# Sets a session item defined by key to val
		def set(key, val)
			@@req.session[key] = val
		end
	end
end