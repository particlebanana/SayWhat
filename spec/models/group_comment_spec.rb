require 'spec_helper'

describe GroupComment do
  context "Factory" do
    before { @comment = Factory.create(:group_comment) }
  
    subject { @comment }  
    it { should belong_to(:user) }
    it { should belong_to(:group) }
  
    it { should validate_presence_of(:comment) }
  end
end