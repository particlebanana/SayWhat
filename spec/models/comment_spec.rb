require 'spec_helper'

describe Comment do
  context "Factory" do
    before { @comment = Factory.create(:comment) }
  
    subject { @comment }  
    it { should belong_to(:user) }
    it { should belong_to(:project) }
  
    it { should validate_presence_of(:comment) }
  end
end