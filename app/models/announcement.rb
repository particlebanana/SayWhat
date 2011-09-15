class Announcement

  # Creates a capped collection that is set at 15 elements
  # to store status like announcements.
  def self.insert(announcement)
    collection.insert(
      title: announcement[:title],
      text: announcement[:text],
      created_at: Time.now
    )
  end

  def self.last
    collection.find().to_a
  end

  private

  def self.collection
    @collection ||= $mongo.create_collection("announcements", :capped => true, :size => 2048, :max => 15)
  end
end