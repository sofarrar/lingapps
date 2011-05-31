class ExpressionsController < ApplicationController
	
	def index
        #puts "***expressions"
        #puts params
  		@expressions = Expression.paginate(:per_page => 10, :page => params[:page])
		
		
		respond_to do |format|
			format.html {render :html => @expressions}
			format.json {render :json => Expression.first}
		end

	end

end
