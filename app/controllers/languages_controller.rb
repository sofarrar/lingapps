class LanguagesController < ApplicationController

	def index
    @title = "All users"
  	@languages = Language.paginate(:per_page => 10, :page => params[:page])
	end

end
