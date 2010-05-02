require 'core/core'

module Picombo
	# == Core
	#
	# The core class for Picombo. Handles system initialization and other core functionality.
	class Core
		# Determines if the request was made on the CLI or not
		def self.cli
			@@cli
		end

		# Standard call function that gets invoked by Rack
		def call
			@@cli = true

			# start system benchmark
			Picombo::Bench.instance.start('application')
			Picombo::Bench.instance.start('loading')

			@@req = Picombo::CLI_Request.new(ARGV[0])

			@@response = Picombo::CLI_Response.new
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

			Picombo::Bench.instance.stop('loading')

			Picombo::Log.write(:debug, 'Picombo Setup Complete')
			output = Picombo::Router.new(@@req).process()

			Picombo::Event.run('system.shutdown')

			output
		end

		# Adds content to the output buffer
		def self.response(str)
			@@response.write(str)
		end

		# Renders output. Returns empty string, because all output should be "puts"'d
		def self.render
			''
		end
	end

	# Overloaded CLI Request object for compatibility
	class CLI_Request
		# Assigns the request path
		def initialize(path)
			@path = path
		end

		# Returns the request path
		def path
			@path
		end
	end

	# Overloaded CLI Response object for compatibility
	class CLI_Response
		@writer = lambda { |x| @body << x }
		@body = []

		# Writes content to the buffer
		def write(str)
			s = str.to_s
			@writer.call s

			str
		end

		# returns the buffer
		def finish
			@body
		end
	end
end