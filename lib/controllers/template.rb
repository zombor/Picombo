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
		# The default template view is called 'layout' which is located in views/layout.rb. You can change this on a per controller basis by changing the @template vartiable in the controller's constructor:
		#
		# 	@template = 'foobar_template'
		#
		# Now, you can use @template in your controller and it will always use the same template. The template will automatically render at the end of the controller execution, so there is no need to call @template.output manually
		class Template
			def initialize
				@template = 'layout' if @template.nil?
				@auto_render = true

				@template = Picombo::Stache::const_get(@template.capitalize).new if @template.is_a?(String)

				Picombo::Event.add('system.post_controller', [self, 'render']) if @auto_render
			end

			def render
				if @auto_render
					if Picombo::Core.cli
						return @template.render
					end

					@template.output
				end
			end
		end
	end
end