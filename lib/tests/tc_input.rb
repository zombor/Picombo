require File.dirname(__FILE__) + '/test_helper'

class TestInput < Test::Unit::TestCase
	include Rack::Test::Methods

	def setup
		require 'dm-core'
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