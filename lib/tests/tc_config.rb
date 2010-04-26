require 'test/unit'
require 'yaml'
require '../core/core'

class TestConfig < Test::Unit::TestCase
	def setup
		$LOAD_PATH.unshift(File.expand_path(Dir.getwd+'../..')+'/')
		$LOAD_PATH.unshift(File.expand_path(Dir.getwd+'../../../application')+'/')
	end

	def test_key_string
		hash = {'foo' => 'bar', 'baz' => {'foo' => 'bar'}}
		assert_equal('bar', Picombo::Config.key_string(hash, 'foo'))
		assert_equal('bar', Picombo::Config.key_string(hash, 'baz.foo'))
		assert_not_equal('barr', Picombo::Config.key_string(hash, 'baz.foo'))
	end

	def test_load
		assert_equal({"directory"=>"logs/", "log_threshold"=>1}, Picombo::Config.load('log'))
	end

	def test_get
		assert_equal(1, Picombo::Config.get('log.log_threshold'))
		assert_equal('http', Picombo::Config.get('config.protocol'))
	end
end