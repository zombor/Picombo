#
# Tests
#

task :default => :test

desc "Run the test suite"
task :test do
	Dir['test/ts_*.rb'].each do |f|
		ruby(f)
	end
end