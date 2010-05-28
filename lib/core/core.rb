# Picombo MVC Web Framework
#
# Author:: Jeremy Bush
# Copyright:: Copyright (c) 2010 Jeremy Bush
# License:: See LICENSE

# Picombo is a Rack-based Ruby MVC web framework with design principles taken from the Kohana PHP Framework.
#
# It's designed to be fast, lightweight and easy to use.

module Picombo
	# == Core
	#
	# The core class for Picombo. Handles system initialization and other core functionality.
	class Core
		@@extension = 'html'
		@@cli = false

		# Determines if the request was made on the CLI or not
		def self.cli
			@@cli
		end

		# Gets the extension of the request
		def self.extension
			@@extension
		end
		# Assigns the extension of the request
		def self.extension=(extension)
			@@extension = extension
		end

		# Standard call function that gets invoked by Rack
		def call(env)
			# start system benchmark
			Picombo::Bench.instance.start('application')
			Picombo::Bench.instance.start('loading')

			@@env = env
			@@req = Rack::Request.new(env)

			@@extension = File.extname(@@req.path)[1..-1]
			@@extension = 'html' if @@extension.nil?

			@@response = Rack::Response.new
			#@@response['Content-Type'] = Picombo::Config.load('mimes.'+@@extension)[0]
			@@response['Content-Type'] = 'text/html'
			@@response.status = 200
			@@redirect = []

			# Add directory extensions to the filesystem
			Picombo::Config.get('config.extensions').each do |extension|
				require extension
			end
			$LOAD_PATH.delete(APPPATH)
			$LOAD_PATH.unshift(APPPATH)

			# Load hooks
			Picombo::Config.get('config.hooks').each do |hook|
				Picombo::Core.find_file('hooks', hook).each do |file|
					require file
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
					files.concat(Dir.new(path+'/'+directory).entries.collect! {|file|
						unless (file == '.' or file == '..')
							path+directory+'/'+file
						end
					})
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

		require 'classes/'+filename.gsub(/_/, '/')

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

			require 'controllers/'+filename.gsub(/_/, '/')

			raise LoadError if ! const_defined?(name)

			klass = const_get(name)
			return klass if klass
			raise LoadError
		end
	end
end