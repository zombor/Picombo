require 'core/core'

module Picombo
	class Core
		def self.cli
			@@cli
		end

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

		def self.response(str)
			@@response.write(str)
		end

		def self.render
			''
		end
	end

	class CLI_Request
		def initialize(path)
			@path = path
		end

		def path
			@path
		end
	end

	class CLI_Response
		@writer = lambda { |x| @body << x }
		@body = []

		def write(str)
			s = str.to_s
			@writer.call s

			str
		end

		def finish
			@body
		end
	end
end