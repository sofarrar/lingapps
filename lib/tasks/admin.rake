namespace :db do
  desc "Fill database with sample data"
  task :admin => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "scott farrar",
                         :email => "sofarrar@gmail.com",
                         :password => "poiuUIOP",
                         :password_confirmation => "poiuUIOP")
    admin.toggle!(:admin)
  end
end
