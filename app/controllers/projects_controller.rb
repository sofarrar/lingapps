class ProjectsController < ApplicationController

	# TODO kelly -- how should we get beyond authentication for query?
	# should we do a custom authentication in 'query' or should we add something to 'signed_in?' in sessions_helper.rb?
	before_filter :authenticate, :except => [:query, :create_salt]
	before_filter :authenticate_salt, :only => [:query]
	
	respond_to :html, :json

	def index
		render 'pages/login'	
	end
	

	def show
  	  @project = Project.find(params[:id])


	end

	# kelly -- adding this to get all projects for a user
	def query	
		@projects = Project.find_all_by_user_id(params[:user_id])
		
		respond_with(@projects)
    end


	def new
		@project = Project.new
	end

	def create
		@language = Language.find_by_name(params[:project][:language])
		
		@language_id = -1
		if @language
			@language_id = @language.id
		else
			flash[:error] = "Could not find language.  Are languages loaded in the DB? "
		end
		
		@project = current_user.projects.build(:name => params[:project][:name], 
			:description => params[:project][:description],	
			:activity => params[:project][:activity],
			:language_id => @language_id,
			:user_id => current_user.id
		)

		
     if @project.save
      flash[:success] = "Successfully created "+@project.name
      redirect_to @project
     end
	 
	 def create_salt
		# TODO kelly -- can I get around duplicating this again?
		@language = Language.find_by_name(params[:project][:language])
		
		@language_id = -1
		if @language
			@language_id = @language.id
		end
		
		@project = current_user.projects.build(:name => params[:project][:name], 
			:description => params[:project][:description],	
			:activity => params[:project][:activity],
			:language_id => @language_id,
			:user_id => current_user.id
		)
	 
  end



	private

    def authenticate
      deny_access unless signed_in?
    end

	def authenticate_salt
      deny_access unless signed_in_salt?
    end

end
