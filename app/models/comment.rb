require "hashie/dash"
require "time"

class Comment < Hashie::Dash

  property :comment
  property :parent, default: nil
  property :timelines, default: []
  property :objects, default: {}

  def initialize(*args)
    super(*args)
  end

  # Initializes a new Comment object and adds attributes
  # based on which type of comment is being created.
  # All comment types must include the comment text and user object.
  #
  # Comment types include:
  #
  #  Group: A comment on a group's timeline
  #     - Requires Group object to not be nil
  #     ex: Comment.build("text", User, Group)
  #
  #  Project: A comment on a group's project timeline
  #     - Requires Group and Project objects to not be nil
  #     ex: Comment.build("text", User, Group, Project)
  #
  #  Nested - A comment response to another comment
  #     - Requires parent param to not be nil and Project and Group to be nil
  #     ex: Comment.build("text", User, nil, nil, "Comment:1234")
  #
  def self.build(text, user, group=nil, project=nil, parent=nil)
    comment = Comment.new({
      comment: text,
      objects: { user: "user:#{user.id}" },
    })

    # Nested Comment
    if parent
      comment.parent = parent
      comment.timelines = ["#{parent}"]
    # Project Comment
    elsif project
      comment.objects.merge!({ group: "group:#{group.id}", project: "project:#{project.id}" })
      comment.timelines = ["project:#{project.id}", "group:#{group.id}"]
      comment.timelines << "user:#{user.id}" unless is_connected?("group:#{group.id}", "user:#{user.id}")
    # Group Comment
    else
      comment.objects.merge!({ group: "group:#{group.id}" })
      comment.timelines = ["group:#{group.id}"]
      comment.timelines << "user:#{user.id}" unless is_connected?("group:#{group.id}", "user:#{user.id}")
    end

    comment
  end

  # Creates a new Chronologic::Event from the comment object.
  # The $feed.publish method returns the new Event object's URL.
  # Save method should do a find in order to return the complete event.
  # This allows the event to be created asynchronously and updated on the
  # timeline if necessary.
  def save
    return false if comment.nil?
    event = Chronologic::Event.new(
      key: "comment:#{Time.now.utc.tv_sec}",
      data: { type: "comment", comment: "#{comment}"},
      timelines: self.timelines,
      objects: self.objects
    )

    event.data.merge!({ parent: self.parent }) unless self.parent.nil?

    url = $feed.publish(event, true, Time.now.utc.tv_sec)
    uri = URI(url)
    path = uri.scheme ? url : "http://localhost:7979#{url}"
    HTTParty.get(path).body
  end

  private

  def self.is_connected?(subscriber_key, timeline_key)
    $feed.connected?(subscriber_key, timeline_key)
  end
end