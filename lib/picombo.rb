# to customize this, place a copy of picombo.rb in your application folder

require 'singleton'
require 'core/core'
require 'classes/config'

# This is where the magic happens!
module Picombo
	module Loader
		def self.run
			return Rack::Builder.new do
				use Rack::Session::Cookie
				run Picombo::Core.new
				puts '-- Starting Picombo Version '+Picombo::Core::VERSION
			end
		end
	end
end