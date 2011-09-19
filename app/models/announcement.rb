# encoding: UTF-8
class Announcement
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :text

  validates_presence_of :title, :text

  before_save :clean_string

  protected

  def clean_string
    self.text.gsub!(/(?i)\b((?:https?:\/\/|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))/) { |x| "<a href='#{x}'>#{x}</a>"}
  end

end