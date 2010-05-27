module Picombo
	module Stache
		class Test < Mustache

			self.template = File.open(Picombo::Core.find_file('views', 'test', true, 'mustache').shift).read

			def whatever
			  "Testing Mustache"
			end

			def rack_version
			  Rack::VERSION
			end

			def base_url
			  Picombo::Url.base()
			end

			def session
			  Picombo::Session.instance.get.inspect
			end

			def get
				Picombo::Input.instance.get.inspect
			end

			def memory
				(`#{'ps -o rss= -p '+Process.pid.to_s}`.to_f/1024.0)
			end
	
			def current_uri
				Picombo::Router.current_uri
			end
	
			def segments
				Picombo::Router.segments.inspect
			end
	
			def controller
				Picombo::Router.controller
			end
	
			def method
				Picombo::Router.method
			end
	
			def all_controllers
				Picombo::Core.list_files('controllers').inspect
			end
		end
	end
end