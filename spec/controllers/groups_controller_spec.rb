require 'spec_helper'

describe GroupsController do
  
  describe "#request_group" do
    request = {
      :group => {
        :name => "Han Shot First",
        :city => "Mos Eisley",
        :organization => "Free Greedo",
        :user => {
          :first_name => "Luke",
          :last_name => "Skywalker",
          :username => "LukeSkywalker",
          :email => "luke.skywalker@gmail.com"
        }
      }
    }
    
    it "should add a pending group" do  
      lambda {
        lambda {
          post :create, request
        }.should change(Group, "count").by(1)
      }.should change(User, "count").by(1)
    end
    
  end
    
  describe "#pending_group" do
    
    before do
      @group = Factory.create(:pending_group)
      login_admin
    end
    
    it "should change a group's status to active" do
      request = {
        :name => "Han Shot First",
        :city => "Mos Eisley",
        :organization => "Free Greedo"
      }
      
      put :approve_group, {:id => @group.id.to_s, :group => request}
      @group = Group.find(@group.id.to_s)
      @group.status.should == "active"
    end
    
  end

end