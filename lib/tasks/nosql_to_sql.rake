#
# Move most model data from the MongoDB collections to a
# MySQL/PostgreSQL relational db while keeping relationships intact.
#

require 'cgi'

namespace :data do

  desc "import all data"
  task :import_all => :environment do
    puts "Beginning Import. This could take a while be patient"
    Rake::Task["data:import_users"].invoke
    Rake::Task["data:import_groups"].invoke
    Rake::Task["data:import_user_group_relationships"].invoke
    Rake::Task["data:import_projects"].invoke
    Rake::Task["data:import_profile_photos"].invoke
    puts "Import is complete."
  end
  
  desc "import user collection data"
  task :import_users => :environment do
    puts "Starting to import User accounts..."
    relationaldb = Mysql2::Client.new(
      host: "localhost",
      username: "root",
      password: "root",
      database: "saywhat_dev")
    documentdb = Mongo::Connection.new("127.0.0.1").db("mongo_restore")
    documentdb["users"].find().each {|user|
      # Build a record object
      record = {
        first_name: CGI.escape(user["first_name"]), 
        last_name: CGI.escape(user["last_name"]), 
        email: CGI.escape(user["email"]),
        role: user["role"],
        status: user["status"],
        encrypted_password: user["encrypted_password"],
        authentication_token: user["authentication_token"]
      }
      
      # Optional Attributes
      record[:bio] = CGI.escape(user["bio"]) if user["bio"]
      record[:reset_password_token] = user["reset_password_token"] if user["reset_password_token"]
      record[:remember_token] = user["remember_token"] if user["remember_token"]
      record[:remember_created_at] = user["remember_created_at"] if user["remember_created_at"]
      record[:sign_in_count] = user["sign_in_count"] if user["sign_in_count"]
      record[:current_sign_in_at] = user["current_sign_in_at"] if user["current_sign_in_at"]
      record[:last_sign_in_at] = user["last_sign_in_at"] if user["last_sign_in_at"]
      record[:current_sign_in_ip] = user["current_sign_in_ip"] if user["current_sign_in_ip"]
      record[:last_sign_in_ip] = user["last_sign_in_ip"] if user["last_sign_in_ip"]
      record[:updated_at] = user["updated_at"] if user["updated_at"]

      if user["created_at"]
        record[:created_at] = user["created_at"]
      else
        # If no created at date is available they prob. joined before we started tracking
        # the date. They are early adopters so just give them the Jan, 1st, 2011
        record[:created_at] = Date.new(2011,01,01)
      end
      
      # Save User To SQL DB
      result = relationaldb.query("INSERT INTO users (first_name, last_name, email, role, status, encrypted_password, authentication_token, created_at, 
      updated_at, bio, reset_password_token, remember_token, remember_created_at, sign_in_count, current_sign_in_at, current_sign_in_ip, last_sign_in_ip) VALUES (
      '#{record[:first_name]}', '#{record[:last_name]}', '#{record[:email]}', '#{record[:role]}', '#{record[:status]}', '#{record[:encrypted_password]}', '#{record[:authentication_token]}', '#{record[:created_at]}', 
      '#{record[:updated_at]}', '#{record[:bio]}', '#{record[:reset_password_token]}', '#{record[:remember_token]}', '#{record[:remember_created_at]}', '#{record[:sign_in_count]}', '#{record[:current_sign_in_at]}', '#{record[:current_sign_in_ip]}', '#{record[:last_sign_in_ip]}')")
    }

    # Loop through each user record and unescape all the values
    @users = User.all
    @users.each do |user|
      user.first_name = CGI.unescape(user.first_name)
      user.last_name = CGI.unescape(user.last_name)
      user.email = CGI.unescape(user.email)
      user.bio = CGI.unescape(user.bio) if user.bio
      user.status = 'active'
      user.save
      user.recreate_object_key
      $feed.subscribe("user:#{user.id}", "global_feed")
    end

    # Post a message to the global feed welcoming users to the new Say What
    event = Chronologic::Event.new(
      key: "global:v2:welcome",
      data: {
        type: "message",
        message: "Welcome to the new Say What! A lot has changed so go explore, collaborate and
        interact with other groups."
      },
      timelines: ["global_feed"],
      objects: { user: "user:2" }
    )
    $feed.publish(event, true, Time.now.utc.tv_sec)

    puts "Finished importing Users"
  end
  
  desc "import group collection data"
  task :import_groups => :environment do
    puts "Starting to import Group models..."
    relationaldb = Mysql2::Client.new(
      host: "localhost",
      username: "root",
      password: "root",
      database: "saywhat_dev")
    documentdb = Mongo::Connection.new("127.0.0.1").db("mongo_restore")
    documentdb["groups"].find().each {|group|
      # Build a record object
      record = {
        name: group["name"],
        display_name: CGI.escape(group["display_name"]),
        city: CGI.escape(group["city"]),
        organization: CGI.escape(group["organization"]),
        permalink: group["permalink"],
        status: group["status"],
        esc_region: group["esc_region"],
        dshs_region: group["dshs_region"],
        area: group["area"],
        created_at: group["created_at"],
        updated_at: group["updated_at"]
      }
      
      # Optional Attributes
      record[:description] = CGI.escape(group["description"]) if group["description"]
      
      # Save Group to SQL DB
      result = relationaldb.query("INSERT INTO groups (name, display_name, city, organization, permalink, status, esc_region, dshs_region, area, created_at, updated_at, description) 
      VALUES ('#{record[:name]}', '#{record[:display_name]}', '#{record[:city]}', '#{record[:organization]}', '#{record[:permalink]}', '#{record[:status]}', '#{record[:esc_region]}', 
      '#{record[:dshs_region]}', '#{record[:area]}', '#{record[:created_at]}', '#{record[:updated_at]}', '#{record[:description]}')")
    }

    # Loop through each group record and unescape all the values
    @groups = Group.all
    @groups.each do |group|
      group.display_name = CGI.unescape(group.display_name)
      group.city = CGI.unescape(group.city)
      group.organization = CGI.unescape(group.organization)
      group.description = CGI.unescape(group.description) if group.description
      group.save
      # Create Object Key
      $feed.unrecord("group:#{group.id}")
      data = { id: group.permalink, name: group.display_name }
      data[:photo] = group.profile_photo_url(:thumb) if group.profile_photo
      $feed.record("group:#{group.id}", data)
    end

    puts "Finished importing Group models"
  end
  
  desc "import user/group relationships"
  task :import_user_group_relationships => :environment do
    puts "Starting to import user/group relationships..."
    relationaldb = Mysql2::Client.new(
      host: "localhost",
      username: "root",
      password: "root",
      database: "saywhat_dev")
    documentdb = Mongo::Connection.new("127.0.0.1").db("mongo_restore")
    groups = []
    documentdb["groups"].find().each{|group| groups << {id: group['_id'].to_s, permalink: group['permalink']}}
    documentdb["users"].find().each {|user|
      if user['group_id']
        group = groups.select {|g| g[:id] == user['group_id'].to_s}
        if group.size > 0
          relationaldb.query("SELECT * FROM groups WHERE permalink='#{group[0][:permalink]}'").each {|group| @group_id = group['id']}
          relationaldb.query("UPDATE users SET group_id='#{@group_id}' WHERE email='#{user['email']}'")
        end
      end
    }

    @users = User.all
    @users.each do |user|
      $feed.subscribe("user:#{user.id}", "group:#{user.group_id}") if user.group_id
    end
    puts "Finished importing user/group relationships"
  end
  
  desc "import projects"
  task :import_projects => :environment do
    puts "Starting to import Project models..."
    relationaldb = Mysql2::Client.new(
      host: "localhost",
      username: "root",
      password: "root",
      database: "saywhat_dev")
    documentdb = Mongo::Connection.new("127.0.0.1").db("mongo_restore")
    documentdb["groups"].find().each {|group|
      if group['projects']

        # Look up group_id in relational table
        relationaldb.query("SELECT * FROM groups WHERE permalink='#{group['permalink']}'").each {|group| @group_id = group['id']}

        group['projects'].each do |project|
          # Build a record object
          record = {
            name: project["name"],
            display_name: CGI.escape(project["display_name"]),
            location: CGI.escape(project["location"]),
            start_date: project["start_date"],
            end_date: project["end_date"],
            focus: CGI.escape(project["focus"]),
            goal: CGI.escape(project["goal"]),
            audience: CGI.escape(project["audience"])
          }

          # Optional Attributes
          record[:description] = CGI.escape(project["description"]) if project["description"]
          record[:involves] = CGI.escape(project["involves"]) if project["involves"]
          record[:updated_at] = project["updated_at"] if project["updated_at"]

          if project["created_at"]
            record[:created_at] = project["created_at"]
          else
            # If no created at date is available they prob. joined before we started tracking
            # the date. They are early adopters so just give them the Jan, 1st, 2011
            record[:created_at] = Date.new(2011,01,01)
          end

          # Save Project to SQL DB
          result = relationaldb.query("INSERT INTO projects (group_id, name, display_name, location, start_date, end_date, focus, goal, description, audience, involves, created_at, updated_at) 
          VALUES ('#{@group_id}', '#{record[:name]}', '#{record[:display_name]}', '#{record[:location]}', '#{record[:start_date]}', '#{record[:end_date]}', '#{record[:focus]}', '#{record[:goal]}', 
          '#{record[:description]}', '#{record[:audience]}', '#{record[:involves]}', '#{record[:created_at]}', '#{record[:updated_at]}')")
        end
      end
    }

    @projects = Project.all
    @projects.each do |project|
      project.display_name = CGI.unescape(project.display_name)
      project.location = CGI.unescape(project.location)
      project.focus = CGI.unescape(project.focus)
      project.goal = CGI.unescape(project.goal)
      project.audience = CGI.unescape(project.audience)
      project.description = CGI.unescape(project.description)
      project.involves = CGI.unescape(project.involves)
      project.save
      # Create Object Key
      $feed.unrecord("project:#{project.id}")
      data = { id: project.id, name: project.display_name }
      data[:photo] = project.profile_photo_url(:thumb) if project.profile_photo
      $feed.record("project:#{project.id}", data)
    end

    puts "Finished importing Project models"
  end
  
  desc "import profile pictures"
  task :import_profile_photos => :environment do
    puts "Starting to import profile photos from GridFS..."
    relationaldb = Mysql2::Client.new(
      host: "localhost",
      username: "root",
      password: "root",
      database: "saywhat_dev")
    documentdb = Mongo::Connection.new("127.0.0.1").db("mongo_restore")
    grid = Mongo::Grid.new(documentdb)

    puts "importing user profile images..."
    # User Profile Images
    documentdb["users"].find().each {|user|
      if user['avatar_filename']
        user_id = user['_id'].to_s
        filename = "avatars/user/avatar/#{user_id}/#{user['avatar_filename']}"
        file_doc = documentdb["fs.files"].find_one({filename: filename})
        file_id = file_doc["_id"]
        raw_file = grid.get(file_id)
        upload_path = Rails.root.join("tmp", "img", "users", user['avatar_filename'])
        File.open(upload_path, 'w:ASCII-8BIT') do |f|
          f.write raw_file.read
        end
        user = User.where(email: user['email']).first
        user.profile_photo = File.open(upload_path)
        user.save!
        user.recreate_object_key
      end
    }

    puts "importing group profile images..."
    # Group Profile Images
    documentdb["groups"].find().each {|group|
      if group['profile_photo_filename']
        group_id = group['_id'].to_s
        filename = "profile/group/profile_photo/#{group_id}/#{group['profile_photo_filename']}"
        file_doc = documentdb["fs.files"].find_one({filename: filename})
        file_id = file_doc["_id"]
        raw_file = grid.get(file_id)
        upload_path = Rails.root.join("tmp", "img", "groups", group['profile_photo_filename'])
        File.open(upload_path, 'w:ASCII-8BIT') do |f|
          f.write raw_file.read
        end
        group = Group.where(permalink: group['permalink']).first
        group.profile_photo = File.open(upload_path)
        group.save!
        # Re-Create Object Key
        $feed.unrecord("group:#{group.id}")
        data = { id: group.permalink, name: group.display_name }
        data[:photo] = group.profile_photo_url(:thumb) if group.profile_photo
        $feed.record("group:#{group.id}", data)
      end
    }

    puts "importing project profile images..."
    # Project Profile Images
    documentdb["groups"].find().each {|group|
      if group['projects']
        group['projects'].each do |project|
          if project['profile_photo_filename']
            project_id = project['_id'].to_s
            filename = "profile/project/profile_photo/#{project_id}/#{project['profile_photo_filename']}"
            file_doc = documentdb["fs.files"].find_one({filename: filename})
            file_id = file_doc["_id"]
            raw_file = grid.get(file_id)
            upload_path = Rails.root.join("tmp", "img", "projects", project['profile_photo_filename'])
            File.open(upload_path, 'w:ASCII-8BIT') do |f|
              f.write raw_file.read
            end
            project = Project.where(name: project['name']).first
            project.profile_photo = File.open(upload_path)
            project.save
            # Re-Create Object Key
            $feed.unrecord("project:#{project.id}")
            data = { id: project.id, name: project.display_name }
            data[:photo] = project.profile_photo_url(:thumb) if project.profile_photo
            $feed.record("project:#{project.id}", data)
          end
        end
      end
    }

    puts "Finished importing profile photos"
  end
end
