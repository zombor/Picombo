require File.dirname(__FILE__) + '/test_helper'

class TestURL < Test::Unit::TestCase
	def test_base
		assert_equal('http://localhost:3000/', Picombo::Url.base())
	end
end