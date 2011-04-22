class Project < ActiveRecord::Base
	belongs_to :user
	has_one :language # :object_language,  :class_name => "Language"	
	has_many :expressions

	#accepts_nested_attributes_for :object_language	
end
