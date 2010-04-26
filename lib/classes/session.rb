module Picombo
	class Session
		include Singleton

		def init(req)
			@@req = req
		end

		def get(key = nil, default = nil)
			return @@req.session if key.nil?

			result = Picombo::Config.key_string(@@req.session, key)

			return result.nil? ? default : result
		end

		def set(key, val)
			@@req.session[key] = val
		end
	end
end