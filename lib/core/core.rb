# Picombo MVC Web Framework
#
# Author:: Jeremy Bush
# Copyright:: Copyright (c) 2010 Jeremy Bush
# License:: See LICENSE

# Picombo is a Rack-based Ruby MVC web framework with design principles taken from the Kohana PHP Framework.
#
# It's designed to be fast, lightweight and easy to use.
# 
# == Filesystem Structure
# 
# Picombo supports automatic class autoloading. This depends on the directory structure of Picombo. It has a few standard structures:
# 
# 	classes/
# 	config/
# 	controllers/
# 	hooks/
# 	models/
# 	views/
# 
# === Classes
# This is the location that general classes go in the filesystem.
# 
# These class names must be in the Picombo module to be properly autoloaded.
# 
# === Config
# This is where config items go. All config files except the Route file should be YAML to be read properly.
# 
# === Controllers
# This is where controllers go (See the controllers doc for more information).
# 
# These class names should be in the Picombo::Controllers module to be properly autoloaded.
# 
# === Hooks
# Hooks go here. You can use hooks to extend/replace/expand system functionality. Hooks run before anything else in the system setup process.
# 
# === Models
# This is where your models go (See the models doc for more information).
# 
# These class names should be in the Picombo::Models module to be properly autoloaded.
# 
# === Views
# This is where views go (See the mustache docs for specific usage).
# 
# If you write a Picombo extension, it's important to know that all extensions should follow this same directory layout. In Picombo, all standard filesystem locations are searched from application first, through the extension list, and finally down to the core system folder. This lets you easily extend and replace functionality with extensions.
# 
# == Autoloading
# As long as your files/classes are setup as above, autoloading will "just work". There's one special case, however: underscores in class names. When you have an underscore in your class name, it will be translated to a directory seperator.
# 
# 	class Picombo::Controllers::Foo_Bar
# 
# lives in:
# 	controllers/foo/bar.rb
# 
# and
# 	class Picombo::Cache_Memcache
# 
# lives in:
# 	classes/cache/memcache.rb
# 
# == Typical Request Flow
# In a typical Picombo request here's how a request get's processed:
# 
# 1. URI comes in from the browser to the server, and is passes to the Router
# 2. The router processes the URI using the routes.rb config file to do any special routing
# 3. The routed URI is the then processed by the appropriate controller
# 4. The controller processes any input, works with Views and Models to generate the request output

module Picombo
	# == Core
	#
	# The core class for Picombo. Handles system initialization and other core functionality.
	class Core
		@@cli = false

		# Determines if the request was made on the CLI or not
		def self.cli
			@@cli
		end

		# Standard call function that gets invoked by Rack
		def call(env)
			# start system benchmark
			Picombo::Bench.instance.start('application')
			Picombo::Bench.instance.start('loading')

			Picombo::Event.clear!

			@@env = env
			@@req = Rack::Request.new(env)

			@@response = Rack::Response.new
			@@response['Content-Type'] = 'text/html'
			@@response.status = 200
			@@redirect = []

			# Add directory extensions to the filesystem
			Picombo::Config.get('config.extensions').each do |extension|
				require extension
			end
			$LOAD_PATH.delete(::APPPATH)
			$LOAD_PATH.unshift(::APPPATH)

			# Load hooks
			Picombo::Config.get('config.hooks').each do |hook|
				Picombo::Core.find_file('hooks', hook).each do |file|
					load file
				end
			end

			## intialize the input library
			Picombo::Input.instance.set_request(@@req)
			Picombo::Session.instance.init(@@req)
			Picombo::Cookie.instance.init(@@req)
			Picombo::Bench.instance.stop('loading')

			Picombo::Log.write(:debug, 'Picombo Setup Complete')
			output = Picombo::Router.new(@@req).process()

			Picombo::Event.run('system.shutdown')

			output
		end

		# Sets a system redirect
		def self.redirect(location, status = 302)
			# Add the base url if a relative path was requested
			location = Picombo::Url.base+location unless location[0..3] == 'http'

			@@redirect = [location, status]
			render
		end

		# Adds content to the output buffer
		def self.response(str, status = 200)
			@@response.status = status
			@@response.write(str)
		end

		# Allows access to raw response object
		def self.raw_response
			@@response
		end

		# Renders the output buffer. Called by Picombo::Router only.
		def self.render
			if ! @@redirect.empty?
				@@response.redirect(*@@redirect)
				return @@response.finish
			end

			Picombo::Event.run('system.display')

			response = @@response.finish
			@@response = Rack::Response.new
			response
		end

		# Finds a file recursively in the CFS.
		#
		# Searches application, then extension locations in order, then system.
		#
		# Returns an array of files that are found
		def self.find_file(directory, file, required = false, ext = 'rb')
			ext = "."+ext

			files = []
			$LOAD_PATH.each do |path|
				if File.exist?(path+'/'+directory+'/'+file+ext)
					files.unshift(path.chomp('/')+'/'+directory+'/'+file+ext)
				end
			end

			raise LoadError if required and files.empty?

			# reverse the array, to put application files first
			return directory == 'config' ? files : files.reverse!
		end

		# Lists all files and directories in a resource path.
		def self.list_files(directory)
			files = []

			$LOAD_PATH.each do |path|
				if File.directory?(path+'/'+directory)
					Dir.new(path+'/'+directory).entries.each do |file|
						unless (file == '.' or file == '..')
							if File.directory?(path+directory+'/'+file)
								list_files(directory+'/'+file).each do |sub_file|
									unless (sub_file == '.' or sub_file == '..' or File.directory?(sub_file))
										files << sub_file
									end
								end
							else
								files << path+directory+'/'+file
							end
						end
					end
				end
			end
			files.delete('.')
			files.delete('..')
			files.compact
		end
	end

	# Autoloader for missing Picombo classes
	def Picombo.const_missing(name)
		filename = name.to_s

		require 'classes/'+filename.downcase.gsub(/_/, '/')

		raise filename+' not found!' if ! const_defined?(name)

		klass = const_get(name)
		return klass if klass
		raise klass+" not found!"
	end

	# == Model Module
	#
	# Models are the back end classes that handle business logic and data access. They accept input from controllers,
	# and can manipulate data sources such as databases and other kinds of data.
	#
	# === Creating Model Files
	#
	# You can use any kind of modeling library to represent your models, such as DataMapper or ActiveRecord.
	# You can also create "raw" models that don't use a library, and directly access a database. You will need
	# to include your own database access methods in this case
	#
	# === Model Naming Conventions
	# * Models live in the Picombo::Models namespace. They must be prefaced with these modules in the file
	# * Models are placed in the /models directory
	# * Model filenames must be named the same as the class name: class Foobar would live in /models/foobar.rb
	# * Model filenames must be lowercase
	module Models
		# Autoloader for missing models
		def Models.const_missing(name)
			filename = name.to_s

			require 'models/'+filename.downcase.gsub(/_/, '/')

			raise filename+' not found!' if ! const_defined?(name)

			klass = const_get(name)
			return klass if klass
			raise klass+" not found!"
		end
	end

	# == Controller Module
	#
	# Controllers are the front level classes that expose your app to the web. They pass information to the model,
	# retrieve information from the model, and pass data to views, which contain the final output for users.
	#
	# === Calling Controllers
	# Controllers are called via URIs, i.e. http://example.com/foobar/baz
	# * Segment #1 is the controller name
	# * Segment #2 is the controller method to call
	#
	# Controller Naming Conventions
	# * Controllers live in the Picombo::Controllers namespace. They must be prefaced with these modules in the file
	# * Controllers are placed in the /controllers directory
	# * Controller filenames must be named the same as the class name: class Foobar would live in /controllers/foobar.rb
	# * Controller filenames must be lowercase
	#
	# === Controller Arguments
	# Controller arguments are passed via URI segments after the second, i.e. http://example.com/foobar/baz/foo/bar
	# * This would match the baz method of the foobar controller, and match the arg1 and arg2 method arguments
	# * def baz(arg1, arg2)
	# The arguments must match the method exactly or a 404 exception will occur
	#
	# === Example Controller
	#
	# 	module Picombo
	# 		module Controllers
	# 			class Foobar
	# 				def index
	# 					Picombo::Core.response('Hello World!')
	# 				end
	# 			end
	# 		end
	# 	end
	# This controller and method could be called via http://example.com/foobar/index
	module Controllers
		# Autoloader for missing controller names
		def Controllers.const_missing(name)
			filename = name.to_s

			require 'controllers/'+filename.downcase.gsub(/_/, '/')

			raise LoadError if ! const_defined?(name)

			klass = const_get(name)
			return klass if klass
			raise LoadError
		end
	end
end