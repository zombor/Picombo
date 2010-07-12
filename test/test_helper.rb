::APPPATH = File.expand_path(File.dirname(__FILE__) + '/../application/')+'/'
SYSPATH = File.expand_path(File.dirname(__FILE__) + '/../lib')+'/'

$LOAD_PATH.unshift(SYSPATH)
$LOAD_PATH.unshift(::APPPATH)

require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'rack/builder'
require 'yaml'
require 'singleton'
require 'core/core'