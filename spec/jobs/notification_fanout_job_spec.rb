require 'spec_helper'

describe NotificationFanoutJob do
  before do
    @group = FactoryGirl.create(:group)
    @user1 = FactoryGirl.create(:user, { email: 'sponsor@test.com', group: @group, role: 'adult sponsor' })
    @user2 = FactoryGirl.create(:user, { email: 'user@test.com', group: @group })
    @project = FactoryGirl.create(:project, { group: @group })
  end

  describe "group comment" do
    describe "#perform" do    
      before do
        @res = NotificationFanoutJob.perform(@user1.id, 'group', @group.id)
      end

      it "should send user2 a notification" do
        notifications_1 = Notification.find_all(@user2.id)
        notifications_1.length.should == 1
        notifications_1[0].text.should == "#{@user1.name} created a new post in your group"
      end

      it "should not send user1 a notification" do
        notifications_1 = Notification.find_all(@user1.id)
        notifications_1.length.should == 0
      end
    end
  end

  describe "project comment" do
    describe "#perform" do    
      before do
        @res = NotificationFanoutJob.perform(@user1.id, 'project', @project.id)
      end

      it "should send user2 a notification" do
        notifications_1 = Notification.find_all(@user2.id)
        notifications_1.length.should == 1
        notifications_1[0].text.should == "#{@user1.name} posted on the project: #{@project.display_name}."
      end

      it "should not send user1 a notification" do
        notifications_1 = Notification.find_all(@user1.id)
        notifications_1.length.should == 0
      end
    end
  end

  describe "child comment" do
    before do
      @timestamp = Time.now.utc.tv_sec

      # Stub out the event POST request
      stub_request(:post,
      "http://localhost:7979/event?fanout=1&force_timestamp=#{@timestamp}").
      to_return(:status => 200, :body => {}, :headers => {"Location" => "/event/comment:#{@timestamp}"})

      # Stub out the is_connected? request
      stub_request(:get,
      "http://localhost:7979/subscription/is_connected?subscriber_key=group:#{@group.id}&timeline_backlink=user:#{@user1.id}").
      to_return(:status => 200, :body => {"group:#{@group.id}" => true}.to_json, :headers => {'Content-Type' => 'application/json'})

      # Stub out the event GET request
      stub_request(:get, "http://localhost:7979/event/comment:#{@timestamp}").
        to_return(:status => 200, :body => {"event"=>{
        "key"=>"comment:#{@timestamp}", 
        "data"=>{"type"=>"comment", "comment"=>"Sweet comment bro"}, 
        "objects"=>{
          "user"=>{"id"=>"#{@user1.id}", "name"=>"#{@user1.name}", "photo"=>"#{@user1.profile_photo_url(:thumb)}"},
          "group"=>{"id"=>"#{@group.permalink}", "name"=>"#{@group.display_name}", "photo"=>"#{@group.profile_photo_url(:thumb)}"}
        }, 
        "subevents"=>[
          {
            "key"=>"comment:1336577900",
            "data"=>{"type"=>"comment", "comment"=>"Test Comment", "parent"=>"comment:1336577846"} ,
            "objects"=>{
              "user"=>{"id"=>"#{@user2.id}", "name"=>"#{@user2.name}", "photo"=>"#{@user2.profile_photo_url(:thumb)}"},
            }, 
            "subevents"=>[], 
            "timelines"=>["comment:1336577846"], 
            "token"=>"1336577900_comment:1336577900"
          },
          {
            "key"=>"comment:1336577901",
            "data"=>{"type"=>"comment", "comment"=>"Sweet comeback bro", "parent"=>"comment:1336577846"} ,
            "objects"=>{
              "user"=>{"id"=>"#{@user1.id}", "name"=>"#{@user1.name}", "photo"=>"#{@user1.profile_photo_url(:thumb)}"},
            }, 
            "subevents"=>[], 
            "timelines"=>["comment:1336577846"], 
            "token"=>"1336577901_comment:1336577901"
          }
        ],
        "timelines"=>["group:1"]}}.to_json,
      :headers => {'Content-Type' => 'application/json'})

      comment_obj = Comment.build("test", @user1, @group)
      @comment = JSON(comment_obj.save)
    end

    describe "#perform" do
      before do
        @res = NotificationFanoutJob.perform(@user1.id, 'child', "comment:#{@timestamp}")
      end

      it "should send user2 a notification" do
        notifications_1 = Notification.find_all(@user2.id)
        notifications_1.length.should == 1
        notifications_1[0].text.should == "#{@user1.name} responded to your comment"
      end

      it "should not send user1 a notification" do
        notifications_1 = Notification.find_all(@user1.id)
        notifications_1.length.should == 0
      end
    end
  end
end