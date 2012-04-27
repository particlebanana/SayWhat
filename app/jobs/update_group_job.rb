# Recreate Group Object Key on Update
class UpdateGroupJob
  @queue = :feed

  # Public: Recreate Group Object Key on Update
  #
  # This job re-creates a group object key when a Group
  # model instance is updated so that the feed stays in
  # sync with the database.
  #
  # group_id - The id of the group
  #
  # Returns nothing. It's a worker task
  def self.perform(group_id)
    group = Group.find(group_id)
    obj = self.new(group)
    obj.recreate_object_key
  end

  def initialize(group)
    @group = group
  end

  # On model update, destroy the current object and recreate it
  def recreate_object_key
    $feed.unrecord("group:#{@group.id}")
    data = { id: @group.permalink, name: @group.display_name }
    data[:photo] = @group.profile_photo_url(:thumb) if @group.profile_photo
    $feed.record("group:#{@group.id}", data)
  end
end