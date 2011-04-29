class TranslationsController < ApplicationController

	def index
    	@title = "All translations"
  		@translations = Translation.paginate(:per_page => 10, :page => params[:page])
		respond_to do |format|
			format.html {render :html => @expressions}
			format.json {render :json => Expression.all}
		end
	end

end
