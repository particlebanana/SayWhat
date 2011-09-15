require 'spec_helper'

describe ProjectComment do
  context "Factory" do
    before { @comment = Factory.create(:project_comment) }
  
    subject { @comment }  
    it { should belong_to(:user) }
    it { should belong_to(:project) }
  
    it { should validate_presence_of(:comment) }
  end
end