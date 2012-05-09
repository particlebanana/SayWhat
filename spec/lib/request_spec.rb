require 'spec_helper'

describe Request do
  before do
    @user = FactoryGirl.create(:user)
  end

  describe "self.find_all" do
    before do
      request = Request.new(@user.id)
      request.insert('test', {id: 123})
      @requests = Request.find_all(@user.id)
    end

    it "should return an array" do
      @requests.is_a? Array
    end

    it "should return 1 request" do
      @requests.count.should == 1
    end
  end

  describe "self.destroy" do
    before do
      request = Request.new(@user.id)
      request.insert('test', {id: 123})
      objs = Request.find_all(@user.id)
      @count = objs.count
      Request.destroy(@user.id, objs.first.id.to_s)
    end

    it "should remove the request from the user's array" do
      @all = Request.find_all(@user.id)
      @all.count.should == @count - 1
    end
  end

  describe "set document" do
    before { @request = Request.new(@user.id) }

    it "should create a new document for the user" do
      @request.requests.count.should == 0
    end
  end

  describe "insert" do
    before do
      request = Request.new(@user.id)
      @resp = request.insert('test', {id: 123})
    end

    it "should return true" do
      @resp.should == true
    end

    it "should append a request obj to the documents requests array" do
      res = Request.find_all(@user.id)
      res.count.should == 1
    end
  end

  describe "destroy" do
    before do
      request = Request.new(@user.id)
      2.times { request.insert('test', {id:123}) }
      id = Request.find_all(@user.id).first.id.to_s
      request.destroy(id)
    end

    it "should remove an item from a users requests" do
      @all = Request.find_all(@user.id)
      @all.count.should == 1
    end
  end
end