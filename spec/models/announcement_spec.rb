require 'spec_helper'

describe Announcement do
  describe "#insert" do
    it "should insert an announcement" do
      obj = { title: "A Test Title", text: "Some awesome text" }
      Announcement.insert(obj).should be_true
    end
  end
  
  describe "#last" do
    before do
      (1..20).each do |i|
        obj = { title: "object #{i}", text: "Some awesome text" }
        Announcement.insert(obj)
      end
    end
    
    it "should return an array of announcements" do
      a = Announcement.last
      a.is_a? Array
    end
    
    it "should cap the collection at 15 elements" do
      a = Announcement.last
      a.count.should == 15
      a[0]["title"].should == 'object 6'
    end
  end
end