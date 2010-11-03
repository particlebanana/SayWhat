require 'spec_helper'

describe GroupsController do
  
  describe "#request_group" do
    request_attributes = {
      :group => {
        :name => "Han Shot First",
        :city => "Mos Eisley",
        :organization => "Free Greedo"
      }
    }
    
    it "should add a pending group" do  
      lambda {
        post :create_request, request_attributes
      }.should change(Group, "count").by(1)
    end
    
  end

end