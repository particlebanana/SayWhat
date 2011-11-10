# Say What! - A Group Collaboration System for Youth Groups

## Overview:

An online group collaboration application developed for the Texas Say What! youth movement.

Allows youth anti-smoking campaigns to collaborate on events and activities as well as share resources with other groups throughout the state.

It is still very much in beta and should not be used unless you fully understand how to troubleshoot problems.

The application is made up of 2 parts: A rails application that is used for the main application as well as a web service named [Chronologic](https://github.com/gowalla/chronologic) that handles the activity feed.

## Requirements:

The application is written in Ruby on Rails and uses MySQL and MongoDB databases. It should be fairly straight forward to setup if you are familiar with setting up a Rails applications. It has been tested in Ruby 1.9.2 and 1.9.3.

- Rails 3.1
- MySQL/PostgreSQL (if using PostgreSQL you will need to edit the Gemfile)
- MongoDB

You will also need a running instance of this [Chronologic Fork](https://github.com/particlebanana/chronologic) which allows you to use MongoDB as the backend for the activity feed. If you use Cassandra you can use the main [Chronologic Fork](https://github.com/gowalla/chronologic).

# Installation:

To install run:
    
    bundle install
  
You will need to create your own database config file from the one in /config/database_example.yml

    cp config/database_example.yml config/database.yml

And a config file from the one in /config/config_example.yml

    cp config/config_example.yml config/config.yml

To setup indexes for MongoDB run:

    rake db:create_indexes

## Updating from previous version

We recently moved to MySQL from MongoDB for a majority of the resources. It was simply too much of a headache dealing with MongoDB for the majority of the data. We still use MongoDB for things like notifications and storing the objects, events and subscriptions for the new activity feed. 

Due to this we had to move a lot of data out of Mongo and into the new relational schema. We also needed to get images out of GridFS and store them locally on the filesystem.

There is a Rake task you can use to help you with this if you choose to update. Just be sure to replace the values for the database names with whatever your own database names are.

I recommend doing a mongodump on the production server and then running the actual rake task on a local or development machine to ensure you don't lose any data.

The rake task is broken up into many smaller tasks if you choose to run them individually. To run the main tasks do:

    rake data:import_all

## Tests

Test are written in RSpec. To run:

    rake spec

## Contributing

As a small non-profit organization we simply don't have the time or resources to devote what we would like to on this. If you would like to use this as a basis for an application in your own organization we would appreciate if you could commit any changes back into this project so that others can share in your organizations awesomeness!

 - Fork.
 - Add, Hack, Tinker and fix stuff.
 - Prove it works with everything else (Test - Rspec &amp; Cucumber)
 - Commit changes.
 - Send me a pull request!
 - Be awesome and proud you helped others

### Credits

Built for use by the [Texas School Safety Center](http://txssc.txstate.edu) and the [TxSayWhat!](http://txsaywhat.com) movement.