class WordListsController < ApplicationController

	def index
    @title = "All Word Lists"
  	@word_lists = WordList.paginate(:per_page => 10, :page => params[:page])
	end

	def show
  	@word_list = WordList.find(params[:id])
		@expressions = @word_list.expressions
	end

end
