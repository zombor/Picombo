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

		assert_equal({:controller => 'lambda', :method => 'index', :params => []}, Picombo::Router.process_uri('/testing/lambdas'))
		assert_equal({:controller => 'bar', :method => 'index', :params => []}, Picombo::Router.process_uri('/foo'))
		assert_equal({:controller => 'city', :method => 'index', :params => ['il', 'chicago']}, Picombo::Router.process_uri('/complex/il/chicago'))
	end

	def test_new
		Picombo::Router.add('foo', 'bar/index')

		Picombo::Router.add('bar', lambda{ |path|
			{:controller => 'lambda', :method => 'index', :params => []} if path == '/testing/lambdas'
		})

		# processes a uri like this: /complex/il/chicago and points it to
		# /city/index/complex/il/chicago
		Picombo::Router.add('complex test', lambda{ |path|
			if Regexp.new('(complex|foobar)/([a-z]{2})/(.+)').match(path)
				{:controller => 'city', :method => 'index', :params => Regexp.last_match[2,3]}
			end
		})
	end
end