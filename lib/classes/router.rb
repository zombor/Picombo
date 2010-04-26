module Picombo

	# Processes the URI to route requests to proper controller
	#
	# == Using Routes
	# Routes are defined in the +config/routes.yaml+:: config file.
	#
	# There should always be a 'default' route, which is the route that applies when there are no uri segments. ex: +default: controller/method+::
	#
	# The first kind of route is an exact match route. This will look for a URI match in the keys of the routes file. ex: +foobar/baz: controller/method+::
	#
	# You can also use regex routes for more powerful routing:
	# * A catch-all route: .+: controller/method
	# * Routing all second URI segments to the index method: foobar/(.+): foobar/index
	# * ([a-z]{2}): chamber/video/\1

	class Router
		@@req = nil

		# Data writer.
		def self.routes=(routes)
			@@routes = routes
		end
		def self.current_uri=(current_uri)
			@@current_uri = current_uri
		end
		def self.current_uri
			@@current_uri
		end
		def self.segments=(segments)
			@@segments = segments
		end
		def self.segments
			@@segments
		end
		def self.rsegments=(rsegments)
			@@rsegments = rsegments
		end
		def self.controller=(controller)
			@@controller = controller
		end
		def self.controller
			@@controller
		end
		def self.method=(method)
			@@method = method
		end
		def self.method
			@@method
		end

		def initialize(req)
			@@req = req
		end

		# Processes the URI
		def process()
			Picombo::Bench.instance.start('setup')

			Picombo::Event.run('system.pre_router')
			# Find the controller and method
			uri = @@req.path
			path = uri[0..-(File.extname(uri).length+1)]
			uri = Picombo::Router.process_uri(path)

			# Let events have the ability to modify the uri array
			Picombo::Event.run('system.post_router', uri)
			@@controller = 'Picombo::Controllers::'+uri[:controller]
			@@method = uri[:method]

			# Try and load the controller class
			begin
				controller = Picombo::Controllers::const_get(uri[:controller].capitalize!).new
			rescue LoadError
				return Picombo::Controllers::Error_404.new.run_error(@@req.path)
			end

			controller_methods = controller.methods

			Picombo::Bench.instance.stop('setup')

			# Execute the controller method
			Picombo::Bench.instance.start('controller_execution')

			Picombo::Event.run('system.pre_controller')
			if controller_methods.include?(uri[:method])
				begin
					if uri[:params].nil? or uri[:params].empty?
						controller.send(uri[:method])
					else
						controller.send(uri[:method], *uri[:params])
					end
				rescue Picombo::E404
					return Picombo::Controllers::Error_404.new.run_error(@@req.path)
				end
			else
				return Picombo::Controllers::Error_404.new.run_error(uri.inspect)
			end
			Picombo::Event.run('system.post_controller')

			Picombo::Bench.instance.stop('controller_execution')
			Picombo::Bench.instance.stop('application')

			Picombo::Core.render
		end

		# Takes a uri path string and determines the controller, method and any get parameters
		# Uses the routes config file for translation
		def self.process_uri(path)
			router_parts = path == '/' ? ('/'+Picombo::Config.get('routes._default')).split('/') : path.split('/')
			@@current_uri = path.split('?').at(0)
			@@segments = @@current_uri.split('/')[1..-1]
			@@rsegments = router_parts[1..-1]
			routed_uri = @@current_uri

			# Load routes
			routes = Picombo::Config.load('routes')

			# Try and find a direct match
			if routes.key?(@@current_uri)
				routed_uri = routes[@@current_uri]
				@@rsegments = routed_uri.split('/')
			else
				routes.each do |route, destination|
					if route != '_default'
						if Regexp.new(route).match(@@current_uri)
							routed_uri.gsub!(Regexp.new(route), destination)
							@@rsegments = routed_uri.split('/')[1..-1]
						end
					end
				end
			end

			params = @@rsegments.slice(2, router_parts.length)

			if ! params.nil?
				params.collect! do |param|
					param.split('?').at(0)
				end
			else
				params = []
			end

			# Use the default route if nothing has been found
			if ! @@rsegments[1].nil?
				@@rsegments[1] = @@rsegments[1].split('?').at(0)
			else
				@@rsegments[1] = ('/'+Picombo::Config.get('routes._default')).split('/').at(2)
			end

			# make sure to remove the GET from any of the parameters
			{:controller => @@rsegments[0].split('?').at(0), :method => @@rsegments[1], :params => params}
		end
	end
end