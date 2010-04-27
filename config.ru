PICOMBO = File.expand_path(Dir.getwd) + '/'
APPPATH = PICOMBO + 'application/'

$LOAD_PATH.unshift(APPPATH)

use Rack::Static, :urls => ['/css', '/images']
use Rack::Reloader
use Rack::ShowExceptions

# app better be defined in here!
require 'picombo'

run run_system()
