class Expression < ActiveRecord::Base
  belongs_to :language
  belongs_to :word_list
	
end
