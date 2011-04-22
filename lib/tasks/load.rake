require 'csv'
namespace :load do


	#load:translations (populates expressions table and translation table)
	#load:languages (populates languages table)
	#load:word_lists (populates expressions and links to wordlists)

	#STRATEGY
	#load translation relation file which contains file names of single-column word lists
	#then load each list of expressions from word lists
	#finally relate expressions in the translation table
	desc "Load Translations"
	task :translations => :environment do
    file_path = File.expand_path(File.join(File.dirname(__FILE__),'../../db/load', 'translations.csv'))
		print "Loading translations \n"

		ActiveRecord::Base.transaction do
			i=0
			CSV.foreach(file_path) do |columns|
				source_file = File.expand_path(File.join(File.dirname(__FILE__),'../../db/load',columns[0]))
				target_file = File.expand_path(File.join(File.dirname(__FILE__),'../../db/load',columns[1]))
				

				source_language = columns[0].scan(/\.[a-z]{3}\./)[0].gsub('.','')
				target_language = columns[1].scan(/\.[a-z]{3}\./)[0].gsub('.','')

				source_expressions = []
				target_expressions = []

				CSV.foreach(source_file) do |source_cols|
					
					#todo: test to see if expression already exists, find_by_form_language ???
					#foo = Expression.find_by_form(source_cols[0])


					e1 = Expression.new(
						:form => source_cols[0],
					  :language_id => Language.find_by_code(source_language).id	
					)	

					e1.save

					source_expressions << e1.id
				end



				CSV.foreach(target_file) do |target_cols|
					

					e2 = Expression.new(
						:form => target_cols[0],
					  :language_id => Language.find_by_code(target_language).id	
					)

					e2.save

					target_expressions << e2.id
	
				end

				#iterate over expression id's
				(0..source_expressions.length).each do |n|

					Translation.create(
						:source_id => source_expressions[n],
						:target_id => target_expressions[n]	
				)
				end
        print '.' if i % 100 == 0
        i += 1
   			
			end
				
		end

    puts "Finished!"
	end


  desc "Load Languages"
  task :languages => :environment do
    # get paths to languages 
    file_path = File.expand_path(File.join(File.dirname(__FILE__),'../../db/load', 'languages.csv'))
    
    print "Loading Languages"
    
    ActiveRecord::Base.transaction do
      i = 0  
      CSV.foreach(file_path) do |columns|
        l = Language.find_by_code(columns[1])
        if l then
          l.name = columns[0]#; l.display = !(columns[2].nil?)
          l.save
        else
          Language.create(
            :name => columns[0],
            :code => columns[1]#,
            #:display => !(columns[2].nil?)
          )
        end
        print '.' if i % 100 == 0
        i += 1
      end
    end
    
    puts "Finished!"

  end



  desc "Load WordLists"
  task :word_lists => :environment do

		puts "start..."

		#get dir *.wordlist 
    file_path = File.expand_path(File.join(File.dirname(__FILE__),'../../db/load'))
    #loop over all *.wordlist files, e.g., swadesh200.eng.wordlist


		Dir.glob(File.join(file_path,'*.wordlist')).each do |file|
      #determine language code assuming this format:
      # swadesh.eng.wordlist
      code = file.scan(/\.[a-z]{3}\./)[0].gsub('.','')
			
			#create the word_list				
			wl_name = file.scan(/[a-z]+[0-9]+\.[a-z]{3}/)[0]
			w = WordList.new(
				:name => wl_name
			)

      #loop over file and create expressions
      CSV.foreach(file) do |columns|
       	puts columns[0] 
        #check to see if expression exists
        e= Expression.find_by_form(columns[0])                       
        if (!e)
          new_e = Expression.new(
            :form => columns[0],

					  :language_id => Language.find_by_code(code).id	
          )
					
					new_e.save
					w.expressions << new_e

        end

      end
			
						

    end

	end

end
