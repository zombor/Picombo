require 'thin'
require 'erb'
require 'yaml'
require 'dm-core'
require 'singleton'
require 'core/core'
require 'classes/config'

def run_system()
	app = Rack::Builder.new do
		use Rack::ShowExceptions
		#use Rack::Reloader
		use Rack::Static, :urls => ['/css', '/images']
		use Rack::Session::Cookie
		run Picombo::Core.new
	end
end
