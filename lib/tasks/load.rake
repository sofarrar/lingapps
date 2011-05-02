require 'csv'
require 'net/ssh'
require 'net/sftp'


namespace :load do


desc 'This loads all data'
task :all => ["load:languages", "load:translations", "load:word_lists"]


	#load:languages (populates languages table)
	#load:translations (populates expressions table and translation table)
	#load:word_lists (populates expressions and links to wordlists)


	desc "Load Languages"
  task :languages => :environment do
    # get paths to languages 
    file_path = File.expand_path(File.join(File.dirname(__FILE__),'../../db/load', 'languages.csv'))
    
    print "Loading Languages...\n"
    
    ActiveRecord::Base.transaction do
      i = 0  
      CSV.foreach(file_path) do |columns|
        l = Language.find_by_code(columns[1])
        if l then
          l.name = columns[0]
          l.save
        else
          Language.create(
            :name => columns[0],
            :code => columns[1]
          )
        end
        print '.' if i % 100 == 0
        i += 1
      end
    end
    
    puts "Finished adding Languages"
  end



	#STRATEGY
	#1. load translation relation file which contains file names of single-column word lists
	#2. then load each list of expressions from word lists
	#3. finally relate expressions in the translation table
	desc "Load Translations"
	task :translations => :environment do
    file_path = File.expand_path(File.join(File.dirname(__FILE__),'../../db/load', 'translations.csv'))
		print "Loading translations... \n"

		ActiveRecord::Base.transaction do
			i=0
			CSV.foreach(file_path) do |columns|
				#STEP 1
				source_file = File.expand_path(File.join(File.dirname(__FILE__),'../../db/load',columns[0]))
				target_file = File.expand_path(File.join(File.dirname(__FILE__),'../../db/load',columns[1]))
				

				source_language_code = columns[0].scan(/\.[a-z]{3}\./)[0].gsub('.','')
				target_language_code = columns[1].scan(/\.[a-z]{3}\./)[0].gsub('.','')

				#puts source_language_code			
				#puts target_language_code			

				#puts "\t\t "+columns[0]+" and "+columns[1]


				source_expressions = []
				target_expressions = []
				
				#STEP 2a, load source expressions
				CSV.foreach(source_file) do |source_cols|

					source_language = Language.find_by_code(source_language_code)
					source_e = Expression.find_by_form_and_language_id(source_cols[0], source_language.id)

					#puts source_language
					#puts source_e					
	
					if (!source_e)

						source_e = Expression.new(
							:form => source_cols[0],
					  	:language_id =>source_language.id	
						)
						source_e.save	
					end
					
						source_expressions << source_e.id
				end


				#STEP 2b, load target expresssion
				CSV.foreach(target_file) do |target_cols|
					
					target_language = Language.find_by_code(target_language_code)

					target_e = Expression.find_by_form_and_language_id(target_cols[0], target_language.id)
					
					if (!target_e)

						target_e = Expression.new(
							:form => target_cols[0],
					  	:language_id => target_language.id	
						)

						target_e.save
					end
						target_expressions << target_e.id
					
				end

				#STEP 3, iterate over expression id's to build translation table
				(0..source_expressions.length-1).each do |n|
			
					trans = Translation.find_by_source_id_and_target_id(source_expressions[n], target_expressions[n])					
					if(!trans)
						Translation.create(
							:source_id => source_expressions[n],
							:target_id => target_expressions[n]	
						)

						#puts "Added "+n.to_s+" translation pairs"
					end
				end
   			
			end
				
		end

    puts "Finished adding translations!"
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
			wl_name = file.scan(/[A-z]+-[0-9]+\./)[0].gsub('.','')
			w = WordList.new(
				:name => wl_name+" ("+Language.find_by_code(code).name+")"
			)
			w.save
      #loop over file and create expressions
      CSV.foreach(file) do |columns|
       	#puts columns[0] 
        #check to see if expression exists
        e= Expression.find_by_form_and_language_id(columns[0], Language.find_by_code(code).id)                       
        if (!e)
          new_e = Expression.new(
            :form => columns[0],
						:word_list_id => w.id,
					  :language_id => Language.find_by_code(code).id	
          )
					
					new_e.save
					w.expressions << new_e

				#if expression does exist
				else
					e.word_list_id = w.id
					e.save
        end

				

      end
			
						

    end

    	puts "Finished adding word_lists"
	end

=begin
	#todo, still need to iterate over translations.csv, like in the above local version
	#of the task
	desc "Load Translations"
	task :translations => :environment do
 

 
   server = 'broadspeak.com'
    username = 'remoteloader'
    password = 'l0@dRunn3r'
    remote_path = "/home/dropbox/lingapps"


 
    Net::SFTP.start(server, username, :password => password) do |sftp|
   
      sftp.dir.glob(remote_path, "*.wordlist") do |entry|
			
				
        file_path = remote_path + "/" + entry.name
        
        puts "Loading '#{file_path}'"

				sftp.file.open(file_path, "r") do |file|

				 ActiveRecord::Base.transaction do
 						while line = file.gets do
              line = line.strip
							next if line.empty?
							puts line	
						end

					end
				end
      end      
    end

  end

=end

end
