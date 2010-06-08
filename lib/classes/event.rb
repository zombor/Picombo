module Picombo
	# == Event Class
	#
	# Process queuing/execution class. Allows an unlimited number of callbacks
	# to be added to 'events'. Events can be run multiple times, and can also
	# process event-specific data. By default, Picombo has several system events.
	#
	# The event class is a powerful system where you can add, modify or remove Picombo functionality, and you can also create your own events to leverage easy plugablity features in your applicetion.
	#
	# === Examples
	# It's very easy to use events to alter system behavior. This event addition will merge some parameters to every controller call:
	# 	Picombo::Event.add('system.post_router') do |data|
	# 		data.merge!({:params => ['test', 'test', 'test']})
	# 	end
	# This event will be called on the system.post_router event, after the router has parsed the URI
	#
	# Because the system.post_router is called as Picombo::Event.run('system.post_router', uri) it passes the routed uri variable as data in the method above.
	#
	# You can also add class methods to events:
	# 	Picombo::Event.add('system.shutdown', 'Picombo::Foobar.new.write_access_log')
	# This might process some data and then write it to an event log on the system.shutdown event right before the output is sent to the browser

	class Event
		private
		# Events that have ran.
		@@ran = []

		# Event-specific data.
		@@data = nil

		# Callbacks.
		@@events = {}

		public
		# Data reader.
		def self.data()
			@@data
		end

		# Data writer.
		def self.data=(data)
			@@data = data
		end

		#
		# Add a callback to an event queue.
		#
		def self.add(name, callback = nil, &block)
			# Create the event queue if it doesn't exist yet.
			unless @@events.include?(name) and ! @@events.empty?
				@@events[name] = []
			end

			# Make sure there isn't a callback and a block, two callbacks at the same time doesn't make sense.
			raise ArgumentError.new('You cannot add a callback to an event queue and specify a block, at the same time.') if ! callback.nil? and block_given?

			if block_given?
				@@events[name].push(block)
			else
				# If the callback is a string/array, make sure it doesn't already exist.
				if ! callback.respond_to?(:call)
					return false if @@events[name].include?(callback)
				end

				@@events[name].push(callback)
			end
		end

		#
		# Return all of the callbacks attached to an event, or an empty array if there are none.
		#
		def self.get(name)
			( ! @@events.include?(name) or @@events[name].empty?) ? [] : @@events[name]
		end

		#
		# Remove one or all of the callbacks from a given event.
		#
		def self.clear!(name = nil, callback = nil)
			@@events = {} if name.nil?

			if callback.nil?
				@@events[name] = []
			else
				@@events[name].delete(callback)
			end
		end

		#
		# Execute all of the callbacks attached to a given event.
		#
		def self.run(name, data = nil)
			# Make sure the event queue exists and has at least one attached callback.
			return false unless @@events.include?(name) and ! @@events[name].empty?

			@@data = data

			@@events[name].each do |callback|
				if callback.is_a?(Array)
					if callback[0].is_a?(String)
						const_get(callback[0]).send(callback[1])
					else
						callback[0].send(callback[1])
					end
				elsif callback.is_a?(String)
					eval(callback)
					#callback = callback.split('.')

					#if callback.length > 1
					#	namespace = Object
					#	callback[0].split("::").each do |const|
					#		namespace = namespace.const_get(const)
					#	end

					#	Picombo::Log.write('info', 'trying to run '+namespace.inspect+'.'+callback[1])
					#	namespace.send(callback[1])
					#else
					#	Kernel.send(callback[0])
					#end
				elsif callback.is_a?(Proc)
					callback.call(data)
				end
			end

			@@ran.push(name)
			@@data = nil
		end

		#
		# Determine whether or not an event has ran yet.
		#
		def self.ran?(name)
			@@ran.include?(name)
		end
	end
end