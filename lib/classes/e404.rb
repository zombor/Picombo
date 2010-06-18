module Picombo
	# == 404 Exception
	# 
	# Main 404 exception class. Used to detect 404 errors in the app.
	# 
	# When you raise a E404 exception, Picombo will instantiate the Picombo::Controllers::Error_404 controller and execute it's run_error() method with the uri passed in. You can override how your 404 pages look by overloading this class.
	class E404 < Exception
		
	end
end