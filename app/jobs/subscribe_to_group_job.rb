# Subscribe a user to a group's timeline
class SubscribeToGroupJob
  @queue = :feed

  # Public: Subscribe a user to a group's timeline
  #
  # This job subscribes a user to a group's timeline
  #
  # user_id - The id of the new user
  #
  # Returns nothing. It's a worker task
  def self.perform(user_id, group_id)
    $feed.subscribe("user:#{user_id}", "group:#{group_id}")
  end
end