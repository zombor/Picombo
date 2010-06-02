module Picombo
	module Controllers
		# == Controller class for handling 404 events
		#
		# To override, re-define this in your application's controller directory
		class Error_404
			# Displays a 404 message for the current uri
			def run_error(uri)
				body = Picombo::Stache::Error_404.new
				body.uri = uri
				return [404, {'Content-Type' => 'text/html'}, body.output]
			end
		end
	end
end