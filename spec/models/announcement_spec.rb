require 'spec_helper'

describe Announcement do
  before { @announcement = Announcement.create( { title: "Test", text: "Test Announcement" } ) }
  
  describe "Validations" do
    subject { @announcement }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:text) }
  end

  describe "#clean_string" do
    before do
      @announcement.text = "This text contains one http://www.test.com/link link."
      @announcement.save
    end

    it "should turn urls in the text into links" do
      @announcement.text.should == "This text contains one <a href='http://www.test.com/link'>http://www.test.com/link</a> link."
    end
  end
end