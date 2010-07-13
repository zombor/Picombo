require File.dirname(__FILE__) + '/test_helper'

class TestCore < Test::Unit::TestCase
	include Rack::Test::Methods

	def setup
		require 'dm-core'
	end

	def app
		Rack::Builder.new {
			run Picombo::Core.new
		}
	end

	def test_find_file
		path = SYSPATH+'classes/router.rb'

		assert_equal(path, Picombo::Core.find_file('classes', 'router').shift);
	end

	def test_list_files
		assert_equal(
			[
				SYSPATH+'views/error/404.mustache',
				SYSPATH+'views/error/404.rb'
			],
			Picombo::Core.list_files('views/error')
		)
	end

	def test_controller_parmeters
		get('/unittest/test_session')
		assert_equal(200, last_response.status)

		get('/unittest/test_cookie')
		assert_equal(404, last_response.status)

		get('/unittest/test_cookie/foo/bar')
		assert_equal(200, last_response.status)
	end
end