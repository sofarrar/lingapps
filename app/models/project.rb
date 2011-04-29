class Project < ActiveRecord::Base
	has_one :user
	has_one :language 	
	has_many :expressions

	has_many :word_lists

	#accepts_nested_attributes_for :object_language	
end
