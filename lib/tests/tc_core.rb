require 'test/unit'
require '../core/core'

class TestCore < Test::Unit::TestCase
	def setup
		$LOAD_PATH.unshift(File.expand_path(Dir.getwd+'../..')+'/')
		$LOAD_PATH.unshift(File.expand_path(Dir.getwd+'../../../application')+'/')
	end

	def test_find_file
		path = File.expand_path(Dir.getwd+'../..')+'/classes/router.rb'

		assert_equal(path, Picombo::Core.find_file('classes', 'router').shift);
	end
end