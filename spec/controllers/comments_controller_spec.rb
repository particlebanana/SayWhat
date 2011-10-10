require 'spec_helper'

describe CommentsController do
  before do
    @user = Factory.create(:user)
    @group = Factory.create(:group)
    sign_in @user
  end

  describe "#create" do
    context "group comment" do
      before do
        post :create, group_id: @group.permalink, comment: "test"
        sleep(1)
      end

      it "should redirect to group#show" do
        response.should redirect_to("/groups/#{@group.permalink}")
      end

      it "should add a comment to timeline" do
        timeline = Hashie::Mash.new($feed.timeline("group:#{@group.id}"))
        timeline.feed.size.should == 1
      end
    end
  end
end