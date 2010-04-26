module Picombo
	# Helper class for security things like xss
	class Security
		# Returns the base URL for use with any internal links.
		def self.xss_clean(str, driver = nil)
			driver = 'default' if driver.nil? or driver == true

			Security.send(driver, str)
		end

		#This is a blacklist method, so ensure this is what you really want
		def self.bitkeeper(str)
			# clean any control characters
			str.gsub!(/[\x00-\x20]*/, '')
			# clean null byte
			str.gsub!(/[\0]/, '')

			# Remove javascript: and vbscript: protocols
			str.gsub!(/([a-z]*)=([`"]*)javascript:/iu, '\1=\2nojavascript....')
			str.gsub!(/([a-z]*)=([`"]*)vbscript:/iu, '\1=\2novbscript....')
			str.gsub!(/#([a-z]*)=(["]*)-moz-binding:/u, '\1=\2nomozbinding...')

			# Only works in IE: <span style="width: expression(alert('Ping!'));"></span>
			str.gsub!(/(<[^>]+?)style=[`"]*.*?expression\([^>]*>/i, '\1>')
			str.gsub!(/(<[^>]+?)style=[`"]*.*?behaviour\([^>]*>/i, '\1>')
			str.gsub!(/(<[^>]+?)style=[`"]*.*?script:*[^>]*>/iu, '\1>')

			# Remove namespaced elements (we do not need them)
			data = str.gsub(/<\/*\w+:\w[^>]*>/i, '')

			begin
				old_data = data
				data.gsub!(/<\/*(?:applet|b(?:ase|gsound|link)|embed|frame(?:set)?|i(?:frame|layer)|l(?:ayer|ink)|meta|object|s(?:cript|tyle)|title|xml)[^>]*>/i, '')
			end until old_data == data

			data
		end

		#default cleaner. encodes the strign to prevent xss
		def self.default(str)
			require 'htmlentities'

			HTMLEntities.new.encode(str)
		end
	end
end