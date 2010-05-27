require 'mustache'

module Picombo
	module Stache
		# Autoloader for missing mustache classes.
		def Stache.const_missing(name)
			filename = name.to_s

			require 'views/'+filename.downcase

			raise name.to_s+' not found!' if ! const_defined?(name)

			klass = const_get(name)
			return klass if klass
			raise klass+" not found!"
		end
	end
end

class Mustache
	def output
		Picombo::Core.response(render)
	end
end