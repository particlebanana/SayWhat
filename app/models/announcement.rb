class Announcement

  def self.insert(announcement)
    collection.insert(
      title: announcement[:title],
      text: announcement[:text],
      created_at: Time.now
    )
  end

  def self.last
    collection.find().sort([['_id', -1]]).limit(15).to_a
  end

  def self.find(id)
    collection.find('_id' => id).first
  end

  private

  def self.collection
    @collection ||= $mongo.create_collection("announcements")
  end
end