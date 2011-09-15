require 'spec_helper'

describe AdminAnnouncementsController do
  before do
    admin = Factory.create(:user, {email: "admin@test.com", role: "admin"})
    sign_in admin
  end
    
  describe "#index" do
    before do
      Announcement.insert({ title: "A Test Title", text: "Some awesome text" })
      get :index
    end
    
    it "should return an array of Announcment objects" do
      assigns[:announcements].is_a? Array
    end
    
    it "should render the index template" do
      response.should render_template('admin_announcements/index')      
    end
  end
  
  describe "#create" do
    describe "with params" do
      before { post :create, { announcement: { title: "Test", text: "Test" } } }

      it "should redirect to index" do
        response.should redirect_to "/admin/announcements"
      end
      
      subject { flash[:notice] }
      it { should  =~ /announcement created successfully/i }
    end
    
    describe "without params" do
      before { post :create }
      
      subject { flash[:alert] }
      it { should  =~ /could not create announcement/i }
    end
  end
end