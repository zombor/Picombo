module Picombo
	module Controllers
		class Error_404
			def run_error(uri)
				body = Picombo::View::Core.new('404')
				body.set('uri', uri)
				return [404, {'Content-Type' => 'text/html'}, body.render(true)]
			end
		end
	end
end