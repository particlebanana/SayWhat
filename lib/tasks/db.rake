namespace :db do

  desc 'Create the indexes defined on your mongoid models'
  task :create_indexes => :environment do
    indexes = File.join(Rails.root, 'db', 'indexes.rb') 
    load(indexes) if File.exist?(indexes)
  end

end