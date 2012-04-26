# Manage Activity Feed Subscriptions on Create
class CreateUserJob
  @queue = :feed

  # Public: Manage Activity Feed Subscriptions for new User
  #
  # This job creates an object key and subscribes a new user
  # to the global activity feed.
  #
  # user_id - The id of the new user
  #
  # Returns nothing. It's a worker task
  def self.perform(user_id)
    user = User.find(user_id)
    obj = self.new(user)
    obj.create_object_key
    obj.subscribe_to_global
  end

  def initialize(user)
    @user = user
  end

  # Create an object in the Activity Feed
  def create_object_key
    $feed.record("user:#{@user.id}", { id: @user.id,  name: @user.name, photo: @user.profile_photo_url(:thumb) } )
  end

  # Subscribe to the Global Activity Feed
  def subscribe_to_global
    $feed.subscribe("user:#{@user.id}", "global_feed")
  end
end