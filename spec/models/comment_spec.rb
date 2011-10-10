require 'spec_helper'

describe Comment do
  before do
    @user = Factory.create(:user)
    @group = Factory.create(:group)
    @user.join_group(@group.id)
    @project = Factory.create(:project, { group: @group } )
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
        @comment['timelines'].count.should == 1
        @comment['timelines'].should == ["project:#{@project.id}"]
      end
    end

    context "nested comment" do
      before do
        obj = Comment.build("test", @user, @group, @project)
        @parent = JSON(obj.save)
        sleep(1)
        @comment = Comment.build("test2", @user, nil, nil, @parent['event']['key'])
      end

      it "should return a comment object" do
        (@comment.is_a? Comment).should be_true
      end

      it "should set the parent attribute" do
        @comment.parent.should == @parent['event']['key']
      end

      it "should create an array of timelines with a length of 1" do
        (@comment['timelines'].is_a? Array).should be_true
        @comment['timelines'].count.should == 1
        @comment['timelines'].should == ["#{@parent['event']['key']}"]
      end
    end
  end

  describe "#save" do
    before do
      comment_obj = Comment.build("test", @user, @group)
      @comment = JSON(comment_obj.save)
    end

    it "should create a new Chronologic::Event" do
      @comment['event']['data']['comment'].should == 'test'
    end
  end
end