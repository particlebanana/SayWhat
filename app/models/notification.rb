class Notification

  attr_accessor :document

  def initialize(user)
    @user = user
    set_collection
    @document = Hashie::Mash.new(set_document)
  end

  def insert(text)
    notification = { text: text, created_at: Time.now }
    append(notification)
    @document = Hashie::Mash.new(set_document)
  end

  # Return all a user's notifications
  def self.find(user)
    obj = self.new(user)
    obj.document.notifications
  end

  private

  # Establish a connection to the mongodb collection
  def set_collection
    db = Mongo::Connection.new.db('Saywhat')
    @collection ||= db.create_collection('notifications')
  end

  #
  # Find the document for the user id
  # If no document exists then create a new one
  #
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
end