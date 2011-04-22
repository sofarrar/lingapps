class ProjectsController < ApplicationController

	before_filter :authenticate
	

	def show
  	@project = Project.find(params[:id])


	end



	def new
		@project = Project.new
	end

	def create
		@language = Language.find_by_code(params[:project][:language])
		
		
		@project = current_user.projects.build(:name => params[:project][:name], 
			:description => params[:project][:description],	
			:activity => params[:project][:activity],
			:language_id => @language.id)

		
   if @project.save
      flash[:success] = "Successfully created "+@project.name
    	redirect_to @project
		end
  end



	private

    def authenticate
      deny_access unless signed_in?
    end



end
