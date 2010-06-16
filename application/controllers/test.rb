module Picombo
	module Controllers
		class Test < Picombo::Controllers::Template
			def initialize
				super
			end

			def index()
				Picombo::Event.add('test', 'Eventtest::Foobar.new().test')

				Picombo::Session.instance.set(:test, 'val')
				@template[:body] = Picombo::Stache::Test.render

				Picombo::Event.run('test')
			end

			def cache
				cache = Picombo::Cache.new
				cache.set(:foo, '<h1>It Works!</h1><p>This is a test.</p>')
				Picombo::Core.response(cache.get(:foo))
			end

			def db_insert(value, test)
				test = Model_Test.new
				test.name = value
				test.save

				'inserted row: '+value.inspect
			end

			def test_redirect
				Picombo::Core.redirect('test/index')
				Picombo::View::Core.new('test').render
			end

			def test_cookie(key, val)
				Picombo::Cookie.set(key, val)

				Picombo::Core.redirect('test/index')
			end

			def test_session
				Picombo::Core.response(Picombo::Session.instance.get.inspect)
			end

			def test404
				raise Picombo::E404
			end
		end
	end
end

module Eventtest
	class Foobar
		def test
			Picombo::Core.response('this is from a namespaced class!')
		end
	end
end