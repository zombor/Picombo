require 'rubygems'
require 'rack/test'
require 'test/unit'
require 'yaml'
require 'erb'
require 'singleton'
require '../core/core'
require 'dm-core'

APPPATH = File.expand_path(Dir.getwd+'../../../application/')+'/'
SYSPATH = File.expand_path(Dir.getwd+'../../../system/')+'/'
EXTPATH = File.expand_path(Dir.getwd+'../../../extensions/')+'/'

class TestCookie < Test::Unit::TestCase
	include Rack::Test::Methods

	def setup
		$LOAD_PATH.unshift(SYSPATH)
		$LOAD_PATH.unshift(APPPATH)
	end

	def app
		Picombo::Core.new
	end

	def test_get
		get('/unittest/test_cookie/test/foobar')
		get('/unittest')

		assert_equal('foobar', Picombo::Cookie.get('test'))
		assert_not_equal('blah', Picombo::Cookie.get('test'))
		assert_equal(nil, Picombo::Cookie.get('picombo'))
	end
end