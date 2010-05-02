module Picombo

	# Helper class to generate HTML
	class Html
		include Singleton

		# Returns a safe email address, by encoding each character in the email
		def self.email(email)
			safe = []

			email.each_byte do |char|
				safe << '&#'+char.to_s
			end

			safe.join
		end

		# Returns a html link tag for +css+
		def self.style(css)
			unless css.is_a? Array
				return '<link type="text/css" href="'+Picombo::Url.base()+css+'" rel="stylesheet" />'
			end

			to_return = ''
			css.each do |file|
				to_return+='<link type="text/css" href="'+Picombo::Url.base()+file+'" rel="stylesheet" />'+"\n"
			end

			to_return
		end

		# Returns a html script tag for +js+
		def self.script(js)
			unless js.is_a? Array
				return '<script type="text/javascript" src="'+Url.base()+js+'"></script>'
			end

			to_return = ''
			js.each do |file|
				to_return+='<script type="text/javascript" src="'+Url.base()+file+'"></script>'+"\n"
			end

			to_return
		end
	end
end