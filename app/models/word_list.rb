class WordList < ActiveRecord::Base
	has_many :expressions
	belongs_to :project
end
