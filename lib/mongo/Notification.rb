class Notification

  # Notification are alerts that an action has happened and the
  # user should be aware of it. They can be deleted without any
  # side-effects and have read/unread states.
  #
  # Notifications are stored in MongoDB as an array under a user id.
  #
  # To get a user's notifications use Notification.find_all(user_id)
  # To destroy a notification call Notification.destroy(user_id, request_id)

  attr_accessor :notifications

  # Find all the notifications belonging to a user
  #
  # user_id - INT, the id of a user
  #
  # Returns an array of notification objects
  def self.find_all(user_id)
    obj = self.new(user_id.to_i)
    obj.notifications
  end

  # Destroy a notification
  #
  # user_id - INT, the id of a user
  # id - STRING, a string version of the notification's BSON id
  #
  # Returns True/False
  def self.destroy(user_id, id)
    obj = self.new(user_id.to_i)
    obj.destroy(id)
  end

  # Return all unread notifications
  #
  # user_id - INT, the id of the user
  #
  # returns an array of notification objects
  def self.unread(user_id)
    obj = self.new(user_id.to_i)
    obj.retrieve
  end

  # Mark a user's notifications as read
  #
  # user_id - INT, the id of the user
  # notification_id - STRING, optional notitification id
  #                   used to mark a single obj as read
  #
  def self.mark_as_read(user_id, notification_id=nil)
    obj = self.new(user_id.to_i)
    @unread = obj.retrieve(notification_id)
    @unread.each do |e|
      e["read_status"] = true
      obj.update(e)
    end
  end

  # Creates a new notification object
  #
  # Stores an array of notifications under a user key in mongo
  #
  # user_id - INT, the id of the user to store the notification for.
  #
  # Returns a notification object
  def initialize(user_id)
    @user = user_id.to_i
    @collection = set_collection
    @notifications = set_document
  end

  # Insert a new notification
  #
  # Appends a new notification object to the document notifications array
  #
  # text - STRING, notification text to write
  #
  # Returns status - True/False
  def insert(text)
    object = { id: BSON::ObjectId.new, text: text, created_at: Time.now }
    if append(object)
      return true
    else
      return false
    end
  end

  # Retrieve notifications
  #
  # If no notification_id is passed in get all unread notification
  #
  # notification_id - STRING, BSON id of a notification
  #
  # returns either an array of notifications or a single notification
  def retrieve(notification_id=nil)
    notification_id.nil? ? get_all_unread : get_single(notification_id)
  end

  # Update a single notification
  #
  # Updates the read status of a notification
  #
  # notification - OBJ, a notification object
  def update(notification)
    @collection.update(
    {'user' => @user,'notifications' => { '$elemMatch' => { 'id' => notification.id } }},
    { "$set" => { 'notifications.$.read_status' => notification.read_status } },
    :multi => true, :upsert => false)
  end

  # Delete a notification from a user's array
  #
  # Removes a single notification object from a user's array of notifications
  #
  # id - STRING, bson id of the request
  #
  # returns status - True/False 
  def destroy(string_id)
    notification_id = BSON::ObjectId.from_string(string_id)
    if @collection.update({'user' => @user}, { "$pull" => { 'notifications' => { 'id' => notification_id } } })
      return true
    else
      return false
    end
  end

  private

  # Establish a connection to the mongodb collection
  # Uses the `notifications` collection.
  #
  # Returns a mongoDB collection obj
  def set_collection
    db = Mongo::Connection.new.db(NOTIFICATIONS_DB)
    return @collection ? @collection : db.create_collection(NOTIFICATIONS_COLL)
  end

  # Look up the document containing the user's notifications
  # If no document exists then create a new one with an empty array
  #
  # Returns the document in a hash {id: INT, notifications: []}
  def set_document
    if document = @collection.find_one('user' => @user)
      Hashie::Mash.new(document).notifications.sort {|x,y| y.id.to_s <=> x.id.to_s }
    else
      @collection.insert({ 'user' => @user, 'notifications' => [] })
      Hashie::Mash.new(@collection.find_one('user' => @user)).notifications.sort {|x,y| y.id.to_s <=> x.id.to_s }
    end
  end

  # Append a notification to the document's notification array
  #
  # object - OBJ, the notification to append
  def append(object)
    object['read_status'] = false
    @collection.update({"user" => @user}, { "$addToSet" => {"notifications" => object } })
  end

  # Get all unread notifications
  def get_all_unread
    @notifications.find_all {|e| e.read_status == false }
  end

  # Get single notification
  #
  # id - STRING, BSON id of the notification to get
  #
  # returns an array of notifications
  def get_single(id)
    key = BSON::ObjectId.from_string(id)
    @notifications.select {|e| e.id == key}
  end
end
