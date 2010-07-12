require File.dirname(__FILE__) + '/test_helper'

class TestCore < Test::Unit::TestCase
	def test_find_file
		path = SYSPATH+'classes/router.rb'

		assert_equal(path, Picombo::Core.find_file('classes', 'router').shift);
	end
end