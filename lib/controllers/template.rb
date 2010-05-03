module Picombo
	module Controllers
		# == Template Controller
		#
		# The template controller enables your application to take advantage of view templating and auto rendering.
		#
		# To use it, simply tell your controllers to extend Picombo::Controllers::Template.
		# You must also explicitly call the parent initialize method in your controllers:
		#
		# 	def initialize
		# 		super
		# 	end
		#
		# The default template view is called 'template' which is located in views/template.rhtml. You can change this on a per controller basis by changing the @@template vartiable in the controller:
		#
		# 	@@template = 'foobar_template'
		#
		# Now, you can use @@template in your controller and it will always use the same template. The template will automatically render at the end of the controller execution, so there is no need to call @@template.render manually
		class Template
			@@template = 'template'
			@@auto_render = true

			def initialize
				@@template = Picombo::View::Core.new(@@template) if @@template.is_a?(String)

				Picombo::Event.add('system.post_controller', 'Picombo::Controllers::Template.render') if @@auto_render
			end

			def self.render
				if @@auto_render
					if Picombo::Core.cli
						return @@template.render(true)
					end

					@@template.render
				end
			end
		end
	end
end