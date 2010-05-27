module Picombo
	module Stache
		class Layout < Mustache
			self.template = File.open(Picombo::Core.find_file('views', 'layout', true, 'mustache').shift).read
		end
	end
end