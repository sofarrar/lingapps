require 'csv'
namespace :load do

  desc "Load Languages"
  task :languages => :environment do
    # get paths to all parallel text
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

end
