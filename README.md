# Say What! - A Group Collaboration System for Youth Groups

## Overview:

An online group collaboration application developed for the Texas Say What! youth movement.

Allows youth anti-smoking campaigns to collaborate on events and activities and share resources with other groups throughout the state.

It is still very much in beta and should not be used unless you fully understand how to troubleshoot problems.

The core applications includes the theme used on [TxSayWhat](http://txsaywhat.com) as well as 2 embedded sinatra applications. These are custom to one specific organization and should be removed or used as a basis in your own versions.

## Requirements:

The application is written in Ruby on Rails and uses a MongoDB database. It should be fairly straight forward to install if you are familiar with setting up a Rails applications.

- Rails 3
- MongoDB via Mongoid ORM

# Installation:

To install run:
    
    bundle install
  
You will need to create your own theme config file from the one in /config/theme_example.yml

    cp config/theme_example.yml config/theme.yml

## Customization:

The system is made to have plug-able themes that are located in the /app/themes folder. From here you can include you own styles and images for use throughout the site. The default is to use SASS stylesheets but you can create your own using plain css.

### Contributing

As a small non-profit organization we simply don't have the time or resources to devote what we would like to on this. If you would like to use this as a basis for an application in your own organization we would appreciate if you could commit any changes back into this project so that others can share in your organizations awesomeness!

 - Fork.
 - Add, Hack, Tinker and fix stuff.
 - Prove it works with everything else (Test - Rspec &amp; Cucumber)
 - Commit changes.
 - Send me a pull request!
 - Be awesome and proud you helped others

### Credits

Built for use by the [Texas School Safety Center](http://txssc.txstate.edu) and the [TxSayWhat!](http://txsaywhat.com) movement.

### License 

(The MIT License)

Copyright (c) 2011 [TxSSC](txssc@txstate.edu)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.