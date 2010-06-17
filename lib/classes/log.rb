module Picombo
	# Provides file logging capability
	#
	# == Log Levels
	# Picombo has the following log levels
	# * 0 - Disable logging (none)
	# * 1 - Errors and exceptions (info)
	# * 2 - Warnings (warning)
	# * 3 - Notices (notice)
	# * 4 - Debugging (debug)
	#
	# The log level is set in config/log.yaml
	#
	# To write a log entry, do Picombo::Log.instance().write(:info, 'This is the message!')
	#
	class Log
		include Singleton

		# Writes log entry with level +type+ with +message+
		def self.write(type, message)
			types = {:none => 0, :info => 1, :warning => 2, :notice => 3, :debug => 4}

			if types[type] <= Picombo::Config.get('log.log_threshold')
				t = Time.now
				f = File.new(::APPPATH+Picombo::Config.get('log.directory')+t.year.to_s+'-'+t.month.to_s+'-'+t.day.to_s+'.log', 'a')
				f.write(t.to_s+' --- '+type.to_s+': '+message.to_s+"\n");
				f.close
			end
		end
	end
end