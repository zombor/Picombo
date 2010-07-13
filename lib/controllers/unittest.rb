module Picombo
	module Controllers
		class Unittest
			def index()
				
			end

			def db_insert(value, test)
				test = Model_Test.new
				test.name = value
				test.save

				'inserted row: '+value.inspect
			end

			def test_redirect
				Picombo::Core.redirect('unittest/index')
				Picombo::View.new('test').render
			end

			def test_cookie(key, val)
				Picombo::Cookie.set(key, val)
			end

			def test_session
				Picombo::Core.response(Picombo::Session.instance.get.inspect)
			end
		end
	end
end