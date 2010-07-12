require File.dirname(__FILE__) + '/test_helper'

class TestBench < Test::Unit::TestCase
	def setup
		$LOAD_PATH.unshift(File.expand_path(Dir.getwd+'../..')+'/')
		$LOAD_PATH.unshift(File.expand_path(Dir.getwd+'../../../application')+'/')
	end

	def test_get
		Picombo::Bench.instance.start('unit_test')
		sleep(2)
		Picombo::Bench.instance.stop('unit_test')
		assert_equal(2, Picombo::Bench.instance.get('unit_test').to_i.round)
	end
end