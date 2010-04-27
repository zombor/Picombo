# to customize this, place a copy of picombo.rb in your application folder

require 'singleton'
require 'core/core'
require 'classes/config'

def run_system()
	app = Rack::Builder.new do
		use Rack::Session::Cookie
		run Picombo::Core.new
	end
end