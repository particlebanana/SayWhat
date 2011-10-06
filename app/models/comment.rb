require "hashie/dash"
require "time"

class Comment < Hashie::Dash

  property :url, default: nil
  property :comment
  property :parent, default: nil
  property :timelines, default: []
  property :objects, default: {}

  def initialize(*args)
    super(*args)
  end

  def save
    return false if comment.nil?
    event = Chronologic::Event.new(
      key: "comment:#{Time.now.utc.tv_sec}",
      data: { type: "comment", comment: "#{comment}"},
      timelines: self.timelines,
      objects: self.objects
    )

    event.data.merge!({ parent: self.parent }) unless self.parent.nil?

    $feed.publish(event, true, Time.now.utc.tv_sec)
  end
end