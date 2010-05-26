module Picombo
	module Controllers
		class Test < Picombo::Controllers::Template
			def initialize
				super
			end

			def index()
				Picombo::Event.add('test', 'Eventtest::Foobar.new().test')

				Picombo::Session.instance.set(:test, 'val')
				body = Picombo::View::Core.new('test')
				body.set('whatever', 'testing a view variable')

				@@template.set('body', body.render(true))

				Picombo::Event.run('test')
			end

			def cache
				cache = Picombo::Cache.new
				cache.set(:foo, '<h1>It Works!</h1><p>This is a test.</p>')
				Picombo::Core.response(cache.get(:foo))
			end

			def xml
				Picombo::Event.clear!('system.display')
				@@template = Picombo::View::XML.new('test.xml')
				@@template.set('name', 'Picombo!')
				@@template.set('language', 'ruby')
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

			def mustache
				@@template.set('body', Picombo::Stache::Test.new.render)
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