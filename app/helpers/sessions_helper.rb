module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end
 
	def current_user
    @current_user ||= user_from_remember_token
	end

	def current_user?(user)
		user == current_user
	end

  def signed_in?
    
	# TODO kelly -- ask Scott why this code was causing problems being in this function.  i thought it would be harmless...
	
	# if a user_id and salt have been provided, let's try to authenticate on them...
	#if params[:user_id] and params[:salt]
	#	current_user = User.authenticate_with_salt(params[:user_id], params[:salt])
	#end
	
	!current_user.nil?
  end
  
  def signed_in_salt?
    
	# if a user_id and salt have been provided, let's try to authenticate on them...
	if params[:user_id] and params[:salt]
		current_user = User.authenticate_with_salt(params[:user_id], params[:salt])
	end
	
	!current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

	def deny_access
    store_location
		redirect_to signin_path, :notice => "Please sign in to access this page."
  end

	def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to		
	end

  private

  def user_from_remember_token
                  User.authenticate_with_salt(*remember_token)
  end

  def remember_token
              cookies.signed[:remember_token] || [nil, nil]
  end


  	def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end

end
