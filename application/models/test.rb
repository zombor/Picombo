module Picombo
	module Models
		class Test# < Picombo::Model
			include DataMapper::Resource

			property :id,	Serial, :key => true
			property :name,	String
			storage_names[:default] = 'test'
		end
	end
end