require 'test/unit'
require 'yaml'
require 'singleton'
require '../core/core'

class TestRouter < Test::Unit::TestCase
	def setup
		$LOAD_PATH.unshift(File.expand_path(Dir.getwd+'../..')+'/')
		$LOAD_PATH.unshift(File.expand_path(Dir.getwd+'../../../application')+'/')
	end

	def test_process
		assert_equal({:controller => 'test', :method => 'index', :params => []}, Picombo::Router.process_uri('/'))
		assert_equal({:controller => 'test', :method => 'index', :params => []}, Picombo::Router.process_uri('/test'))
		assert_equal({:controller => 'test', :method => 'index', :params => []}, Picombo::Router.process_uri('/test/index'))
		assert_equal({:controller => 'test', :method => 'index', :params => ['param1', 'param2']}, Picombo::Router.process_uri('/test/index/param1/param2'))
		assert_equal({:controller => 'test', :method => 'index', :params => []}, Picombo::Router.process_uri('/test/index?foo=bar'))
		assert_equal({:controller => 'test', :method => 'index', :params => ['param1']}, Picombo::Router.process_uri('/test/index/param1?foo=bar'))
	end
end