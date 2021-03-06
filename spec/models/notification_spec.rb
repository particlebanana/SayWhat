require 'spec_helper'

describe Notification do
  before do
    @user = FactoryGirl.create(:user)
    @message = {
      text: 'this is a test notification',
      link: '/test_link'
    }
  end

  describe "self.find_all" do
    before do
      notification = Notification.new(@user.id)
      notification.insert(@message)
      @notifications = Notification.find_all(@user.id)
    end

    it "should return an array" do
      @notifications.is_a? Array
    end

    it "should return 1 notification" do
      @notifications.count.should == 1
    end
  end

  describe "self.destroy" do
    before do
      notification = Notification.new(@user.id)
      notification.insert(@message)
      objs = Notification.find_all(@user.id)
      @count = objs.count
      Notification.destroy(@user.id, objs.first.id.to_s)
    end

    it "should remove the notification from the user's array" do
      @all = Notification.find_all(@user.id)
      @all.count.should == @count - 1
    end
  end

  describe "self.unread" do
    before do
      2.times do |i|
        notification = Notification.new(@user.id)
        notification.insert(@message)
        @notifications = Notification.unread(@user.id)
      end
    end

    it "should return an array" do
      @notifications.is_a? Array
    end

    it "should return 2 notifications" do
      @notifications.count.should == 2
    end
  end

  describe "self.mark_as_read" do
    before :each do
      2.times do |i|
        notification = Notification.new(@user.id)
        notification.insert(@message)
      end
    end

    context "mark all" do
      before do
        Notification.mark_as_read(@user.id)
        @notifications = Notification.find_all(@user.id)
      end

      it "should set read status to all notifications to true" do
        @notifications.each do |e|
          e.read_status.should be_true
        end
      end
    end

    context "mark single" do
      before do
        @notification = Notification.find_all(@user.id).first
        Notification.mark_as_read(@user.id, @notification.id.to_s)
        @notifications = Notification.find_all(@user.id)
      end

      it "should set status to single notification to true" do
        notification = @notifications.find_all {|e| e.id == @notification.id }.first()
        notification.read_status.should == true
      end

      it "should not change any other notifications" do
        read, unread = [], []
        @notifications.each do |e|
          e.read_status == false ? unread.push(e) : read.push(e)
        end
        read.count.should == 1
        unread.count.should == 1
      end
    end
  end

  describe "set document" do
    before { @notification = Notification.new(@user.id) }

    it "should create a new document for the user" do
      @notification.notifications.count.should == 0
    end
  end

  describe "insert" do
    before do
      @notification = Notification.new(@user.id)
      @notification.insert(@message)
    end

    it "should append a notification obj to the documents notification array" do
      @notification.notifications.count.should == 1
    end
  end

  describe "destroy" do
    before do
      @notification = Notification.new(@user.id)
      2.times { @notification.insert(@message) }
      id = @notification.notifications.first.id.to_s
      @notification.destroy(id)
    end

    it "should remove an item from a users notifications" do
      @all = Notification.find_all(@user.id)
      @all.count.should == 1
    end
  end
end