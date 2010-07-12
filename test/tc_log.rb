require File.dirname(__FILE__) + '/test_helper'

class TestBench < Test::Unit::TestCase
	def test_process
		Picombo::Log.write(:info, 'This is a unit test')
		t = Time.now
		f = File.open(::APPPATH+Picombo::Config.get('log.directory')+t.year.to_s+'-'+t.month.to_s+'-'+t.day.to_s+'.log', 'r').readlines.pop

		assert_equal(t.to_s+" --- info: This is a unit test\n", f)
	end
end