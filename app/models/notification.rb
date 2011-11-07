class Notification

  attr_accessor :notifications

  # Return all a user's notifications
  def self.find_all(user)
    obj = self.new(user)
    obj.notifications
  end

  def self.destroy(user, id)
    obj = self.new(user)
    obj.destroy(id)
  end

  # Return all unread notifications
  def self.unread(user)
    obj = self.new(user)
    obj.retrieve
  end

  # Mark a user's notifications as read
  def self.mark_as_read(user, notification=nil)
    obj = self.new(user)
    @unread = obj.retrieve(notification)
    @unread.each do |e|
      e["read_status"] = true
      obj.update(e)
    end
  end

  def initialize(user)
    @config = Mongo_Config['notifications']["#{Rails.env.downcase}"]
    @user = user
    set_collection
    @notifications = set_document
  end

  # Insert a notification
  def insert(message)
    object = { id: BSON::ObjectId.new, text: message[:text], created_at: Time.now }
    object[:link] = message[:link] if message[:link]
    append(object)
    @notifications = set_document
  end

  # Retrieve notifications
  def retrieve(notification=nil)
    notification.nil? ? get_all_unread : get_single(notification)
  end

  # Update a single notification
  def update(notification)
    @collection.update(
    {
      'user' => @user,
      'notifications' => { '$elemMatch' => { 'id' => notification.id } }
    }, { "$set" => { 'notifications.$.read_status' => notification.read_status } },
    :multi => true, :upsert => false)
  end

  # Delete a single notification
  def destroy(string_id)
    notification_id = BSON::ObjectId.from_string(string_id)
    @collection.update(
    {
      'user' => @user
    }, { "$pull" => { 'notifications' => { 'id' => notification_id } } })
  end

  private

  # Establish a connection to the mongodb collection
  def set_collection
    db = Mongo::Connection.new.db(@config['database'])
    @collection ||= db.create_collection('notifications')
  end

  # Find the document for the user id
  # If no document exists then create a new one
  def set_document
    if document = @collection.find_one('user' => @user)
      Hashie::Mash.new(document).notifications.sort {|x,y| y.id.to_s <=> x.id.to_s }
    else
      @collection.insert({ 'user' => @user, 'notifications' => [] })
      Hashie::Mash.new(@collection.find_one('user' => @user)).notifications.sort {|x,y| y.id.to_s <=> x.id.to_s }
    end
  end

  # Append a notification to the document's notification array
  def append(object)
    object['read_status'] = false
    @collection.update({"user" => @user}, { "$addToSet" => {"notifications" => object } })
  end

  # Get all unread notifications
  def get_all_unread
    @notifications.find_all {|e| e.read_status == false }
  end

  # Get single notification
  def get_single(id)
    key = BSON::ObjectId.from_string(id)
    @notifications.select {|e| e.id == key}
  end
end