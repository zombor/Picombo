module Picombo
	module Stache
		class Error_404 < Mustache
			self.template = File.open(Picombo::Core.find_file('views', 'error/404', true, 'mustache').shift).read

			@uri = nil

			def uri=(uri)
				@uri = uri
			end

			def uri
				@uri
			end
		end
	end
end