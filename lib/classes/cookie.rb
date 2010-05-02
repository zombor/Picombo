module Picombo
	# == Cookie handling class
	#
	# In essense, a proxy to the rack cookie handling methods.
	#
	# == Example usage
	# Writing cookie values
	# 	Picombo::Cookie.set(:sample, 'this is the content of the cookie')
	#
	# Getting cookie values
	# 	Picombo::Cookie.get(:sample)
	#
	# Deleting a cookie
	# 	Picombo::Cookie.delete(:sample)
	class Cookie
		include Singleton

		# Initializes the request for cookies
		def init(req)
			@@req = req
		end

		# Retrieves a cookie item defined by key
		def self.get(key, default = nil)
			return @@req.cookies[key] if @@req.cookies.has_key?(key)

			default
		end

		# Sets a cookie item defined by key to val
		def self.set(key, val)
			Picombo::Core.raw_response.set_cookie(key, val)
		end

		# Deletes a cookie item defined by key
		def self.delete(key)
			Picombo::Core.raw_response.delete_cookie(key)
		end
	end
end