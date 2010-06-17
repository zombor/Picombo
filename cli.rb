# Root path
PICOMBO = File.expand_path(Dir.getwd) + '/'
# Application Path
::APPPATH = PICOMBO + 'application/'

$LOAD_PATH.unshift(::APPPATH)

# app better be defined in here!
require 'rubygems'
require 'singleton'
require 'core/core_cli'
require 'classes/config'

puts Picombo::Core.new.call