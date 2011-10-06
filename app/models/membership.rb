class Membership < ActiveRecord::Base
  
  # Handles Group Membership Request
  #
  # This is a perfect use case for adding Redis into the stack
  # however at this time that is impossible on my end due to
  # server restrictions. Will look into for future updates.
  belongs_to :user
  belongs_to :group
  
  validates_presence_of [:user_id, :group_id]

  def publish
    event = Chronologic::Event.new(
      key: "membership:#{self.user_id}:create",
      data: { type: "message", message: "joined the group" },
      timelines: ["group:#{self.group_id}"],
      objects: { group: "group:#{self.group_id}", user: "user:#{self.user_id}" }
    )
    $feed.publish(event, true, Time.now.utc.tv_sec)
  end
end
