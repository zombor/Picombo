::APPPATH = File.expand_path(File.dirname(__FILE__) + '/../lib')+'/'
SYSPATH = File.expand_path(File.dirname(__FILE__) + '/../lib')+'/'

$LOAD_PATH.unshift(SYSPATH)

require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'rack/builder'
require 'yaml'
require 'singleton'
require 'core/core'