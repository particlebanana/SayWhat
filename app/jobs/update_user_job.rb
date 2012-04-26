# Recreate User Object Key on Update
class UpdateUserJob
  @queue = :feed

  # Public: Recreate User Object Key on Update
  #
  # This job re-creates a user object key when a User
  # model instance is updated so that the feed stays in
  # sync with the database.
  #
  # user_id - The id of the new user
  #
  # Returns nothing. It's a worker task
  def self.perform(user_id)
    user = User.find(user_id)
    obj = self.new(user)
    obj.recreate_object_key
  end

  def initialize(user)
    @user = user
  end

  # On model update, destroy the current object and recreate it
  def recreate_object_key
    $feed.unrecord("user:#{@user.id}")
    data = { id: @user.id, name: @user.name }
    data[:photo] = @user.profile_photo_url(:thumb) if @user.profile_photo
    $feed.record("user:#{@user.id}", data)
  end
end