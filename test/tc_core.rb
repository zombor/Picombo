require File.dirname(__FILE__) + '/test_helper'

class TestCore < Test::Unit::TestCase
	def test_find_file
		path = SYSPATH+'classes/router.rb'

		assert_equal(path, Picombo::Core.find_file('classes', 'router').shift);
	end

	def test_list_files
		assert_equal(
			[
				'/Users/jeremybush/code/picombo.git/lib/views/error/404.mustache',
				'/Users/jeremybush/code/picombo.git/lib/views/error/404.rb'
			],
			Picombo::Core.list_files('views/error')
		)
	end
end