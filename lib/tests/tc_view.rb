require 'test/unit'
require 'yaml'
require 'erb'
require '../core/core'

class TestView < Test::Unit::TestCase
	def setup
		$LOAD_PATH.unshift(File.expand_path(Dir.getwd+'../..')+'/')
		$LOAD_PATH.unshift(File.expand_path(Dir.getwd+'../../../application')+'/')
	end

	def test_render
		view = Picombo::View::Core.new('tests/test')
		view.set('test', 'test')
		
		assert_equal('Test test', view.render(true))
	end
end