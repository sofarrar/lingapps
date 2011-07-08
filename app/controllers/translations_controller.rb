class TranslationsController < ApplicationController

	respond_to :html, :json

	def index
    	@title = "All translations"
  		@translations = Translation.paginate(:per_page => 10, :page => params[:page])
		respond_to do |format|
			format.html {render :html => @expressions}
			format.json {render :json => Expression.all}
		end
	end
	
	def create
		
		Logger.new(STDOUT).info('translations#create')
		
		# get the source language id
		@source_language = Language.find_by_name(params[:translation][:source][:language])
		@source_language_id = -1
		if @source_language
			@source_language_id = @source_language.id
		end
		
		# get the target language id
		@target_language = Language.find_by_name(params[:translation][:target][:language])
		@target_language_id = -1
		if @target_language
			@target_language_id = @target_language.id
		end
		
		# source expression
		@source_exp = Expression.new(:form => params[:translation][:source][:form], :language_id => @source_language_id)
		@source_exp.save
		
		# target expression
		@target_exp = Expression.new(:form => params[:translation][:target][:form], :language_id => @target_language_id)
		@target_exp.save
	
		# now let's associate these into a translation in the project...
		@project = Project.find_by_id(params[:translation][:project_id])
		# TODO -- do i want to pass in the expression IDs or the expressions themselves?
		@translation = @project.translations.build(:source => @source_exp, :target => @target_exp)
		
		if @translation.save
			respond_with do |format|                                                
				format.html do                                                      
					redirect_to @translation 
				end
                                                                        
				#for json                                                           
				format.json {respond_with @translation}                                     
			end                                                                                                                                       
		end
	end

end
