class ExpressionsController < ApplicationController
	
	def index


  		@expressions = Expression.paginate(:per_page => 10, :page => params[:page])
		
		
		respond_to do |format|
			format.html {render :html => @expressions}
			format.json {render :json => Expression.all}
		end

	end

end
