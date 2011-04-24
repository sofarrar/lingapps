class TranslationsController < ApplicationController

	def index
    @title = "All translations"
  	@translations = Translation.paginate(:per_page => 10, :page => params[:page])
	end

end
