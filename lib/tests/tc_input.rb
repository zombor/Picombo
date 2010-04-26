require 'rubygems'
require 'rack/test'
require 'test/unit'
require 'yaml'
require 'erb'
require 'singleton'
require '../core/core'
require 'dm-core'

class TestInput < Test::Unit::TestCase
	include Rack::Test::Methods

	def setup
		$LOAD_PATH.unshift(SYSPATH)
		$LOAD_PATH.unshift(APPPATH)
	end

	def app
		Picombo::Core.new
	end

	def test_get
		get('/unittest/index?foo=bar')

		assert_equal('bar', Picombo::Input.instance().get('foo'))
		assert_equal(nil, Picombo::Input.instance().get('baz'))
		assert_equal('baz', Picombo::Input.instance().get('foobar', 'baz'))
	end

	def test_post
		post('/unittest/index', {'foo' => 'bar'})

		assert_equal('bar', Picombo::Input.instance().post('foo'))
		assert_equal(nil, Picombo::Input.instance().post('baz'))
		assert_equal('baz', Picombo::Input.instance().post('foobar', 'baz'))
	end
end