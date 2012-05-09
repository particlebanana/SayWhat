require 'spec_helper'

describe CommentsController do
  before do
    @user = FactoryGirl.create(:user)
    @group = FactoryGirl.create(:group)
    sign_in @user
  end

  describe "#create" do
    context "group comment" do
      before do
        timestamp = Time.now.utc.tv_sec

        # Return True showing user is subscribed to the group
        stub_request(:get,
          "http://localhost:7979/subscription/is_connected?subscriber_key=group:#{@group.id}&timeline_backlink=user:#{@user.id}").
          to_return(:status => 200, :body => {"group:#{@group.id}" => true}.to_json, :headers => {'Content-Type' => 'application/json'})

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

        post :create, group_id: @group.permalink, comment: "test"
      end

      it "should redirect to group#show" do
        response.should redirect_to("/groups/#{@group.permalink}")
      end

      it "should queue a NotificationFanoutJob" do
        NotificationFanoutJob.should have_queued(@user.id, 'group', @group.id)
      end
    end
  end
end