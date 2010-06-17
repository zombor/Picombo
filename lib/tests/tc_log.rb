require 'test/unit'
require 'yaml'
require 'singleton'
require '../core/core'

::APPPATH = File.expand_path(Dir.getwd+'../../../application/')+'/'
SYSPATH = File.expand_path(Dir.getwd+'../../../system/')+'/'
EXTPATH = File.expand_path(Dir.getwd+'../../../extensions/')+'/'

class TestBench < Test::Unit::TestCase
	def setup
		$LOAD_PATH.unshift(File.expand_path(Dir.getwd+'../..')+'/')
		$LOAD_PATH.unshift(File.expand_path(Dir.getwd+'../../../application')+'/')
	end

	def test_process
		Picombo::Log.write(:info, 'This is a unit test')
		t = Time.now
		f = File.open(::APPPATH+Picombo::Config.get('log.directory')+t.year.to_s+'-'+t.month.to_s+'-'+t.day.to_s+'.log', 'r').readlines.pop

		assert_equal(t.to_s+" --- info: This is a unit test\n", f)
	end
end