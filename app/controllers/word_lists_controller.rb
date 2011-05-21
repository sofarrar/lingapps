class WordListsController < ApplicationController

	def index
        @title = "All Word Lists"
  	    @word_lists = WordList.paginate(:per_page => 10, :page => params[:page])
	
        respond_to do |format|
			format.html {render :html => @word_lists}
			format.json {render :json => WordList.all}
		end


    
    
    end

	def show
  	@word_list = WordList.find(params[:id])
		@expressions = @word_list.expressions
	end

end
