require 'spec_helper'

describe GroupsController do
  
  describe "#request_group" do
    request_attributes = {
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
          post :create_request, request_attributes
        }.should change(Group, "count").by(1)
      }.should change(User, "count").by(1)
    end
    
  end

end