#
# Run report data to create a CSV file export
#

require 'cgi'
require 'csv'

namespace :report do
  
  desc "report on project details"
  task :run_projects do
    relationaldb = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "saywhat_dev")
    documentdb = Mongo::Connection.new("127.0.0.1").db("saywhat_development")
    
    reports = [] # To hold report hash items
    
    CSV.open("data-export.csv", "wb") do |csv|
      
      # Write CSV Headers
      csv << ['Group Name', 'Project Name', 'Project Description', 'Youth Reached', 'Adult Reached']
    
      documentdb["groups"].find().each {|group|
      
        if group['projects']
          # Look up group in relational table
          relationaldb.query("SELECT * FROM groups WHERE permalink='#{group['permalink']}'").each {|group| @group = group}
        
          # Loop through projects looking for reports
          group['projects'].each do |project|
            if project['report']
              reports << {group: CGI.unescape(@group['display_name']), project: project['display_name'], project_description: project['description'], youth: project['report']['number_of_youth_reached'], adult: project['report']['number_of_adults_reached']}
            end
          end
        end
      }
      
      reports.each do |report|
        csv << [report[:group], report[:project], report[:project_description], report[:youth], report[:adult]]
      end
      
    end
    
  end
end