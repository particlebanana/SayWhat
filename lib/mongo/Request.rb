class Request

  # Requests are notifications that have a task attached them.
  # When a request is made it means the user has to make an action
  # before the request can be removed. Similar to something like a
  # friend request on facebook.
  #
  # Requests are stored in MongoDB as an array under a user id.
  #
  # To get a user's requests use Request.find_all(user_id)
  # To destroy a request call Request.destroy(user_id, request_id)

  attr_accessor :requests

  # Find all the requests belonging to a user
  #
  # user_id - INT, the id of a user
  #
  # Returns an array of request objects
  def self.find_all(user_id)
    obj = self.new(user_id.to_i)
    obj.requests
  end

  # Destroy a request
  #
  # user_id - INT, the id of a user
  # id - STRING, a string version of the request's BSON id
  #
  # Returns True/False
  def self.destroy(user_id, id)
    obj = self.new(user_id.to_i)
    obj.destroy(id)
  end

  # Creates a new Request object
  #
  # Stores an array of requests under a user key in mongo
  #
  # user_id - INT, the id of the user to store the request for.
  #
  # Returns a request object
  def initialize(user_id)
    @user = user_id.to_i
    @collection = set_collection
    @requests = set_document
  end

  # Insert a new request
  #
  # Appends a new request object to the document requests array
  # 
  # Returns a hash of requests for a user
  def insert(klass, data=nil)
    object = { id: BSON::ObjectId.new, klass: klass, data: data, created_at: Time.now }
    if append(object)
      return true
    else
      return false
    end
  end

  # Delete a request from a user's array
  #
  # Removes a single request object from a user's array of requests
  #
  # id - STRING, bson id of the request
  #
  # returns status - True/False 
  def destroy(id)
    request_id = BSON::ObjectId.from_string(id)
    if @collection.update({'user' => @user}, { "$pull" => { 'requests' => { 'id' => request_id } } })
      return true
    else
      return false
    end
  end

  private

  # Establish a connection to the mongodb collection
  # Uses the `requests` collection.
  #
  # Returns a mongoDB collection obj
  def set_collection
    db = Mongo::Connection.new.db(REQUESTS_DB)
    return @collection ? @collection : db.create_collection(REQUESTS_COLL)
  end

  # Look up the document containing the user's requests
  # If no document exists then create a new one with an empty array
  #
  # Returns the document in a hash {id: INT, requests: []}
  def set_document
    if document = @collection.find_one('user' => @user)
      Hashie::Mash.new(document).requests.sort {|x,y| y.id.to_s <=> x.id.to_s }
    else
      @collection.insert({ 'user' => @user, 'requests' => [] })
      Hashie::Mash.new(@collection.find_one('user' => @user)).requests.sort {|x,y| y.id.to_s <=> x.id.to_s }
    end
  end

  # Append a request to the document's requests array
  def append(object)
    @collection.update({"user" => @user}, { "$addToSet" => {"requests" => object } })
  end
end