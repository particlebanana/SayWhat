#
# Move most model data from the MongoDB collections to a
# MySQL/PostgreSQL relational db while keeping relationships intact.
#

namespace :data do
  
  desc "import user collection data"
  task :import_users do
    relationaldb = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "saywhat_dev")
    documentdb = Mongo::Connection.new("127.0.0.1").db("saywhat_development")
    documentdb["users"].find().each {|user|
      # Build a record object
      record = {
        first_name: user["first_name"], 
        last_name: user["last_name"], 
        email: user["email"],
        role: user["role"],
        status: user["status"],
        encrypted_password: user["encrypted_password"],
        authentication_token: user["authentication_token"],
        created_at: user["created_at"],
        updated_at: user["updated_at"]
      }
      
      # Optional Attributes
      record[:bio] = user["bio"] if user["bio"]
      record[:reset_password_token] = user["reset_password_token"] if user["reset_password_token"]
      record[:remember_token] = user["remember_token"] if user["remember_token"]
      record[:remember_created_at] = user["remember_created_at"] if user["remember_created_at"]
      record[:sign_in_count] = user["sign_in_count"] if user["sign_in_count"]
      record[:current_sign_in_at] = user["current_sign_in_at"] if user["current_sign_in_at"]
      record[:last_sign_in_at] = user["last_sign_in_at"] if user["last_sign_in_at"]
      record[:current_sign_in_ip] = user["current_sign_in_ip"] if user["current_sign_in_ip"]
      record[:last_sign_in_ip] = user["last_sign_in_ip"] if user["last_sign_in_ip"]
      
      # Save User To SQL DB
      result = relationaldb.query("INSERT INTO users (first_name, last_name, email, role, status, encrypted_password, authentication_token, created_at, 
      updated_at, bio, reset_password_token, remember_token, remember_created_at, sign_in_count, current_sign_in_at, current_sign_in_ip, last_sign_in_ip) VALUES (
      '#{record[:first_name]}', '#{record[:last_name]}', '#{record[:email]}', '#{record[:role]}', '#{record[:status]}', '#{record[:encrypted_password]}', '#{record[:authentication_token]}', '#{record[:created_at]}', 
      '#{record[:updated_at]}', '#{record[:bio]}', '#{record[:reset_password_token]}', '#{record[:remember_token]}', '#{record[:remember_created_at]}', '#{record[:sign_in_count]}', '#{record[:current_sign_in_at]}', '#{record[:current_sign_in_ip]}', '#{record[:last_sign_in_ip]}')")
    }
  end
  
  desc "import group collection data"
  task :import_groups do
    relationaldb = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "saywhat_dev")
    documentdb = Mongo::Connection.new("127.0.0.1").db("saywhat_development")
    documentdb["groups"].find().each {|group|
      # Build a record object
      record = {
        name: group["name"],
        display_name: group["display_name"],
        city: group["city"],
        organization: group["organization"],
        permalink: group["permalink"],
        status: group["status"],
        esc_region: group["esc_region"],
        dshs_region: group["dshs_region"],
        area: group["area"],
        created_at: group["created_at"],
        updated_at: group["updated_at"]
      }
      
      # Optional Attributes
      record[:description] = group["description"] if group["description"]
      
      # Save Grouo to SQL DB
      result = relationaldb.query("INSERT INTO groups (name, display_name, city, organization, permalink, status, esc_region, dshs_region, area, created_at, updated_at) 
      VALUES ('#{record[:name]}', '#{record[:display_name]}', '#{record[:city]}', '#{record[:organization]}', '#{record[:permalink]}', '#{record[:status]}', '#{record[:esc_region]}', '#{record[:dshs_region]}',
      '#{record[:area]}', '#{record[:created_at]}', '#{record[:updated_at]}')")
    }
  end
  
end