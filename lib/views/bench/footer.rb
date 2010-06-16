module Picombo
	module Stache
		class Bench_Footer < Mustache
			self.template = File.open(Picombo::Core.find_file('views', 'bench/footer', true, 'mustache').shift).read

			def loading
				Picombo::Bench.instance.get('loading')
			end

			def setup
				Picombo::Bench.instance.get('setup')
			end

			def controller_execution
				Picombo::Bench.instance.get('controller_execution')
			end

			def application
				Picombo::Bench.instance.get('application')
			end
		end
	end
end