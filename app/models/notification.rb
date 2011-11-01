class Notification

  attr_accessor :document

  # Return all a user's notifications
  def self.find(user)
    obj = self.new(user)
    obj.document.notifications
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
    @document = Hashie::Mash.new(set_document)
  end

  # Insert a notification
  def insert(text, link)
    notification = { id: BSON::ObjectId.new, text: text, link: link, created_at: Time.now }
    append(notification)
    @document = Hashie::Mash.new(set_document)
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
      document
    else
      @collection.insert({ 'user' => @user, 'notifications' => [] })
      @collection.find_one('user' => @user)
    end
  end

  # Append a notification to the document's notification array
  def append(notification)
    notification["read_status"] = false
    @collection.update({"user" => @user}, { "$addToSet" => {"notifications" => notification } })
  end

  # Get all unread notifications
  def get_all_unread
    @document.notifications.find_all {|e| e.read_status == false }
  end

  # Get single notification
  def get_single(id)
    key = BSON::ObjectId.from_string(id)
    @document.notifications.select {|e| e.id == key}
  end
end