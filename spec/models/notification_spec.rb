require 'spec_helper'

describe Notification do
  before(:each) { @user = Factory.create(:user) }

  describe "set document" do
    before { @notification = Notification.new(@user.id) }

    it "should create a new document for the user" do
      @notification.document.notifications.count.should == 0
    end
  end

  describe "insert" do
    before do
      @notification = Notification.new(@user.id)
      @notification.insert('this is a test notification', '/test_link')
    end

    it "should append a notification obj to the documents notification array" do
      @notification.document.notifications.count.should == 1
    end
  end

  describe "self.find" do
    before do
      notification = Notification.new(@user.id)
      notification.insert('this is a test notification', '/test_link')
      @notifications = Notification.find(@user.id)
    end

    it "should return an array" do
      @notifications.is_a? Array 
    end

    it "should return 1 notification" do
      @notifications.count.should == 1
    end
  end
end