require File.dirname(__FILE__) + '/test_helper'

class TestRouter < Test::Unit::TestCase
	def setup
		$LOAD_PATH.unshift(File.expand_path(Dir.getwd+'../..')+'/')
		$LOAD_PATH.unshift(File.expand_path(Dir.getwd+'../../../application')+'/')

		Picombo::Router.add('foo', 'bar/index')

		Picombo::Router.add('bar',
			lambda{ |path|
				{:controller => 'lambda', :method => 'index', :params => []} if path == 'testing/lambdas'
			},
			'lambda/index'
		)

		# processes a uri like this: /complex/il/chicago and points it to
		# /city/index/complex/il/chicago
		Picombo::Router.add('complex test', # route name
			lambda{ |path| # route rules
				if Regexp.new('(complex|foobar)/([a-z]{2})/(.+)').match(path)
					last_match = Regexp.last_match
					{
						:controller => 'city',
						:method => 'index',
						:params => last_match[2,3]
					}
				end
			},
			'{type}/{state}/{city}' # route default style, for reverse routing
		)
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

	# test reverse routes
	def test_reverse
		assert_equal(
			'foobar/wi/kenosha',
			Picombo::Router.generate('complex test', {:type => 'foobar', :state => 'wi', :city => 'kenosha'})
		)

		assert_equal(
			'lambda/index',
			Picombo::Router.generate('bar')
		)

		# This one doesn't have a reverse route
		assert_equal(nil, Picombo::Router.generate('foo'))
	end
end