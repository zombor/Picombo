module Picombo
	# Helper class to assist in URL generation
	class Url
		# Returns the base URL for use with any internal links.
		def self.base(protocol = nil)
			protocol = Picombo::Config.get('config.protocol') if protocol.nil?
			protocol+"://"+Picombo::Config.get('config.site_domain')+'/'
		end

		# Creates a full URL using the base path plus the path passed to the method
		def self.site(path, protocol = nil)
			base(protocol)+path
		end
	end
end