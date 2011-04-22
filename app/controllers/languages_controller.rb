class LanguagesController < ApplicationController

	def index
    @title = "All languages"
  	@languages = Language.paginate(:per_page => 10, :page => params[:page])
	end

end
