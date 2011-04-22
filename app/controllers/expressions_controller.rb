class ExpressionsController < ApplicationController

	def index
    @title = "All expressions"
  	@expressions = Expression.paginate(:per_page => 10, :page => params[:page])
	end

end
