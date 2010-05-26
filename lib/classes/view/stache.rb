module Picombo
	module View
		# == XML View
		#
		# The core view renders XML to the browser
		#
		# See the View documentation for usage specifics
		class Stache < Mustache
			# Standard constructor
			def initialize(filename)
				super(filename)

				# Changes the content type to xml for the application
				Picombo::Core.raw_response()['Content-Type'] = 'text/xml'
			end
		end
	end
end