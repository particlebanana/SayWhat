require 'spec_helper'

describe Comment do
  before do
    @user = FactoryGirl.create(:user)
    @group = FactoryGirl.create(:group)
    @project = FactoryGirl.create(:project, { group: @group } )

    # Mocks

    # Return True showing user is subscribed to the group
    stub_request(:get,
      "http://localhost:7979/subscription/is_connected?subscriber_key=group:#{@group.id}&timeline_backlink=user:#{@user.id}").
      to_return(:status => 200, :body => {"group:#{@group.id}" => true}.to_json, :headers => {'Content-Type' => 'application/json'})
  end

  describe ".build" do
    context "group timeline" do
      before { @comment = Comment.build("test", @user, @group) }

      it "should return a comment object" do
        (@comment.is_a? Comment).should be_true
      end

      it "should create a hash with 2 comment objects" do
        (@comment['objects'].is_a? Hash).should be_true
        @comment['objects'].count.should == 2
      end

      it "should create an array of timelines" do
        (@comment['timelines'].is_a? Array).should be_true
        @comment['timelines'].count.should == 1
        @comment['timelines'].should == ["group:#{@group.id}"]
      end
    end

    context "project timeline" do
      before { @comment = Comment.build("test", @user, @group, @project) }

      it "should return a comment object" do
        (@comment.is_a? Comment).should be_true
      end

      it "should create a hash with 3 comment objects" do
        (@comment['objects'].is_a? Hash).should be_true
        @comment['objects'].count.should == 3
      end

      it "should create an array of timelines with a length of 1" do
        (@comment['timelines'].is_a? Array).should be_true
        @comment['timelines'].count.should == 2
        @comment['timelines'].should == ["project:#{@project.id}", "group:#{@group.id}"]
      end
    end

    context "nested comment" do
      before do
        @key = "comment:#{Time.now.utc.tv_sec}"
        @comment = Comment.build("test2", @user, nil, nil, @key)
      end

      it "should return a comment object" do
        (@comment.is_a? Comment).should be_true
      end

      it "should set the parent attribute" do
        @comment.parent.should == @key
      end

      it "should create an array of timelines with a length of 1" do
        (@comment['timelines'].is_a? Array).should be_true
        @comment['timelines'].count.should == 1
        @comment['timelines'].should == ["#{@key}"]
      end
    end
  end

  describe "#save" do
    before do
      timestamp = Time.now.utc.tv_sec

      # Stub out the event POST request
      stub_request(:post,
      "http://localhost:7979/event?fanout=1&force_timestamp=#{timestamp}").
      to_return(:status => 200, :body => {}, :headers => {"Location" => "/event/comment:#{timestamp}"})

      # Stub out the event GET request
      stub_request(:get, "http://localhost:7979/event/comment:#{timestamp}").
        to_return(:status => 200, :body => {"event"=>{"key"=>"comment:#{timestamp}", "data"=>{"type"=>"comment", "comment"=>"test"},
        "objects"=>{"user"=>{"id"=>"#{@user.id}", "name"=>"#{@user.name}", "photo"=>"#{@user.profile_photo_url(:thumb)}"},
        "group"=>{"id"=>"#{@group.permalink}", "name"=>"#{@group.display_name}"}},
        "timelines"=>["group:#{@group.id}"], "subevents"=>[]}}.to_json,
        :headers => {'Content-Type' => 'application/json'})

      comment_obj = Comment.build("test", @user, @group)
      @comment = JSON(comment_obj.save)
    end

    it "should create a new Chronologic::Event" do
      @comment['event']['data']['comment'].should == 'test'
    end
  end
end