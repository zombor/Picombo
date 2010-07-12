#
# Tests
#

task :default => :test

desc "Run the test suite"
task :test do
	Dir['lib/tests/ts_*.rb'].each do |f|
		ruby(f)
	end
end