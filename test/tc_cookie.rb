require File.dirname(__FILE__) + '/test_helper'

class TestCookie < Test::Unit::TestCase
	include Rack::Test::Methods

	def setup
		require 'dm-core'
	end

	def app
		Rack::Builder.new {
			run Picombo::Core.new
		}
	end

	def test_get
		get('/unittest/test_cookie/test/foobar')
		get('/unittest')

		assert_equal('foobar', Picombo::Cookie.get('test'))
		assert_equal(nil, Picombo::Cookie.get('picombo'))
	end
end