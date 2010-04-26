module Picombo
	# == View Class
	#
	# The Picombo::View class allows for template files to be rendered and displayed in the browser.
	#
	# By default, only ERB templating is currently supported.
	# === Examples
	#
	# 	foobar = Picombo::View::Core.new('template')
	# 	# Sets a view variable
	# 	foobar.set('bar', 'baz')
	# 	# Renders the view to the output buffer
	# 	foobar.render
	#
	# You can also nest views like so:
	# 
	# 	body = Picombo::View::Core.new('page/body')
	# 	body.set('content', 'Hello World!')
	# 	template = Picombo::View::Core.new('template')
	# 	template.set('body', body.render(true))
	# 	template.render
	#
	# This will render a body subview inside of your template view file
	module View
		# == Core View
		#
		# The core view renders HTML to the browser using ERB
		#
		# See the View documentation for usage specifics
		class Core
			@view_file = ''
			@view_data = []

			# Creates a new view object and sets the filename. Raises an IOError exception if the view file is not found
			def initialize(filename)
				@view_data = {}
				view_location = Picombo::Core.find_file('views', filename, false, 'rhtml').shift

				if view_location.nil?
					raise IOError
				end

				@view_file = view_location
			end

			# Support templating of member data.
			def get_binding
				binding
			end

			# Sets a view variable
			def set(key, val)
				instance_variable_set "@#{key}", val
			end

			# Renders the view to the output buffer, or optionally simply returns it if echo is true
			def render(echo = false)
				view = ERB::new(File.read(@view_file))

				if echo
					view.result(get_binding())
				else
					Picombo::Core.response view.result(get_binding())
				end
			end
		end

		def View.const_missing(name)
			filename = name.to_s

			require 'classes/view/'+filename.downcase

			raise name.to_s+' not found!' if ! const_defined?(name)

			klass = const_get(name)
			return klass if klass
			raise klass+" not found!"
		end
	end
end