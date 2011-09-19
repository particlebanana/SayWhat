class Announcement
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :text

  validates_presence_of :title, :text
end