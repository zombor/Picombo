require 'mustache'

module Picombo
	# == Mustache Module
	# 
	# Picombo comes with builtin support for Mustache view templates
	# 
	# === How to use
	# 
	# All view files go into the views folder. You need a .rb class along with a .mustache template file. Your view class files should extend the Mustache class:
	# 
	# 	module Picombo
	# 		module Stache
	# 			class Home_Index < Mustache
	# 				self.template = File.open(Picombo::Core.find_file('views', 'home/index', true, 'mustache').shift).read
	# 			end
	# 		end
	# 	end
	# 
	# You should always set the template in your class. In most scenarios, it's easiest to read it in from a file as displayed above. You can also specify a raw string template there and not do the file read.
	# 
	# To render the template to your browser, use the output method:
	# 	Picombo::Stache::Home_Index.new.output
	module Stache
		# Autoloader for missing mustache classes.
		def Stache.const_missing(name)
			filename = name.to_s

			require 'views/'+filename.downcase.gsub(/_/, '/')

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