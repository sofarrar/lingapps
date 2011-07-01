class ExpressionsController < ApplicationController

    respond_to :html, :json

	def index
  		@expressions = Expression.paginate(:per_page => 10, :page => params[:page])
		
		respond_with do |format|
			format.html {render :html => @expressions}
			format.json {render :json => @expressions}
		end

	end

    def show
        @expression = Expression.find(params[:id])        
    end

    def new
        @expression = Expression.new
    end

    def create
      @language = Language.find_by_name(params[:expression][:language_id])
     
      #prints the language and word list, not id???
      #puts "***"
      #puts params[:expression][:language_id] 
      #puts params[:expression][:word_list_id] 

      @expression = Expression.new({
        :form=>params[:expression][:form],
        :language_id=>params[:expression][:language_id], 
        :word_list_id=>params[:expression][:word_list_id]})

      
     if @expression.save
        respond_with do |format|                                                
            format.html do                                                      
              flash[:success] = "Successfully created " + @expression.form
              redirect_to @expression 
            end
                                                                        
            #for json                                                           
            format.json {respond_with @expression}                                     
        end                                                                     
                                                                                
    end
  end
end



