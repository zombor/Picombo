module Picombo
	# == Benchmarking Class
	#
	# The benchmark class allows you to run simple named benchmarks.
	#
	# === Usage
	#
	# To start a benchmark, use the Picombo::Bench.instance.start(name) method. Name should be unique to the benchmark being ran.
	# 	# Start a simple benchmark
	# 	Picombo::Bench.instance.start(:myapp_simple_mark)
	#
	# To stop a benchmark, use the Picombo::Bench.instance.stop(name) method.
	# 	# Stop the previous benchmark
	# 	Picombo::Bench.instance.stop(:myapp_simple_mark)
	#
	# You can retrieve the benchmark results anytime after you stop the benchmark with Picombo::Bench.instance.get(name)
	# 	# Retrieve the previously ran benchmark
	# 	time = Picombo::Bench.instance.get(:myapp_simple_mark)
	#
	# You can alter the precision of the returned benchmark time with the second parameter, it defaults to four decimal places
	# 	# Only go to two decimal places
	# 	time = Picombo::Bench.instance.get(:myapp_simple_mark, 2)
	#
	# get() will return nil if the named benchmark doesn't exist
	class Bench
		include Singleton

		# Internal hash of benchmarks
		@@marks = {}

		# Starts a benchmark defined by name
		def start(name)
			@@marks[name] = {'start' => Time.new,
			                'stop'  => nil}
		end

		# Stops a benchmark defined by name
		def stop(name)
			# only stop if the benchmark exists
			if (@@marks.has_key?(name))
				@@marks[name]['stop'] = Time.new
			end
		end

		# Gets a benchmark result defined by name
		def get(name, precision = 4)
			if ( ! @@marks.has_key?(name))
				return nil
			else
				start = @@marks[name]['start'].to_f
				stop = @@marks[name]['stop'].to_f
				rounded_number = (Float((stop-start)) * (10 ** precision)).round.to_f / 10 ** precision
				return rounded_number.to_s
			end
		end
	end
end