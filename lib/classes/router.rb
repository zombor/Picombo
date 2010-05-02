module Picombo

	# Processes the URI to route requests to proper controller
	#
	# == Using Routes
	# Routes are defined in the +config/routes.rb+ config file.
	#
	# There should always be a '_default' route, which is the route that applies when there are no uri segments. ex: +Picombo::Router.add('_default', 'controller/method')+
	#
	# The first kind of route is an exact match route. This will look for a URI match in the keys of the routes file. ex: +Picombo::Router.add('foobar/baz', 'controller/method')+
	#
	# You can also use regex routes for more powerful routing:
	# * A catch-all route: Picombo::Router.add('(.+)', 'controller/method')
	# * Routing all second URI segments to the index method: Picombo::Router.add('foobar/(.+)', 'foobar/index')
	# * Picombo::Router.add('([a-z]{2})', 'chamber/video/\1')
	#
	# === Using lambdas for routes
	# You can use lamba methods for complex routing schemes that rely on extra logic. The first parameter to the lambda method is the source uri as a string
	#
	# 	Picombo::Route.add('my complex route', lambda{ |path|
	# 			if Regexp.new('(complex|foobar)/([a-z]{2})/(.+)').match(path)
	# 				{:controller => 'city', :method => 'index', :params => Regexp.last_match[2,3]}
	# 		end
	#  })

	class Router
		@@req = nil
		@@routes = {}

		# Assigns the current uri of the request
		def self.current_uri=(current_uri)
			@@current_uri = current_uri
		end
		# Reads the current uri of the request
		def self.current_uri
			@@current_uri
		end
		# Assigns the current segments of the request
		def self.segments=(segments)
			@@segments = segments
		end
		# Reads the current segments of the request
		def self.segments
			@@segments
		end
		# Assigns the current rsegments of the request
		def self.rsegments=(rsegments)
			@@rsegments = rsegments
		end
		# Assigns the current controller of the request
		def self.controller=(controller)
			@@controller = controller
		end
		# Reads the current controller of the request
		def self.controller
			@@controller
		end
		# Assigns the current method of the request
		def self.method=(method)
			@@method = method
		end
		# Reads the current method of the request
		def self.method
			@@method
		end

		# Initializes the request
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

		# Adds a route to the router
		# 
		# * key - the name of the route (optionally the source URI for simple routes)
		# * val - the destination of the route (optionally a lambda for complex routes)
		def self.add(key, val, style = nil)
			@@routes[key] = {:val => val, :generate => style}
		end

		# Generates a routed URI based on paramaters
		def self.generate(key, params = [])
			raise ArgumentError.new('The route: "'+key+'" doesn\'t exist!') if ! @@routes.key?(key)
			route = @@routes[key]

			routing_string  = route[:generate]

			params.each do |key, value|
				routing_string.gsub!('{'+key.to_s+'}', value)
			end

			routing_string
		end

		# Takes a uri path string and determines the controller, method and any get parameters
		# Uses the routes config file for translation
		def self.process_uri(path)

			# Load routes
			Picombo::Core.find_file('config', 'routes').each do |file|
				require file
			end

			router_parts = path == '/' ? ('/'+@@routes['_default'][:val]).split('/') : path.split('/')
			@@current_uri = path.split('?').at(0)
			@@segments = @@current_uri.split('/')[1..-1]
			@@rsegments = router_parts[1..-1]
			routed_uri = @@current_uri

			# Try and find a direct match
			if @@routes.key?(@@current_uri)
				routed_uri = @@routes[@@current_uri][:val]
				@@rsegments = routed_uri.split('/')
			else
				@@routes.each do |route, destination|
					if destination[:val].is_a?(Proc)
						route = destination[:val].call(@@current_uri)
						return route if ! route.nil?
					else
						if Regexp.new(route).match(@@current_uri)
							routed_uri.gsub!(Regexp.new(route), destination[:val])
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
				@@rsegments[1] = ('/'+@@routes['_default'][:val]).split('/').at(2)
			end

			# make sure to remove the GET from any of the parameters
			{:controller => @@rsegments[0].split('?').at(0), :method => @@rsegments[1], :params => params}
		end
	end
end