class Project < ActiveRecord::Base
	has_one :user
	has_one :language # :object_language,  :class_name => "Language"	
	has_many :translations
	has_many :participants

	#accepts_nested_attributes_for :object_language	
end
