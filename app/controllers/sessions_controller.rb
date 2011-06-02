class SessionsController < ApplicationController
  
    #added by sof
    respond_to :html, :json

  def new
    @title = "Sign in"
  
  end

   def create 

    user = User.authenticate(params[:session][:email],
                                   params[:session][:password])


    if user.nil?
        flash.now[:error] = "Invalid email/password combination."
        @title = "Sign in"
        render 'new'
    else
        
        #with only html
        #sign_in user
        #redirect_back_or user
        
        #added by sof
        respond_with do |format|
            format.html do 
                sign_in user 
                redirect_back_or user
            end
			#for json
            format.json {respond_with user}
		end


    end
  
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
