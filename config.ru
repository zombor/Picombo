
PICOMBO = File.expand_path(Dir.getwd) + '/'
APPPATH = PICOMBO + 'application/'
#SYSPATH = '../picombo/trunk/system/'
#EXTPATH = PICOMBO + 'extensions/'

#$LOAD_PATH.unshift(SYSPATH)
#$LOAD_PATH.unshift(EXTPATH)
$LOAD_PATH.unshift(APPPATH)

# app better be defined in here!
# to customize this, place a copy of bootstrap.rb in your application folder
require 'bootstrap'

run run_system()
