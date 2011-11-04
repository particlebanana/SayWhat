require 'spec_helper'

describe AdminAnnouncementsController do
  before do
    admin = FactoryGirl.create(:user, {email: "admin@test.com", role: "admin"})
    sign_in admin
  end
    
  describe "#index" do
    before do
      Announcement.create( { title: "A Test Title", text: "Some awesome text" } )
      get :index
    end
    
    it "should return an array of Announcment objects" do
      (assigns[:announcements].map {|e| e}.is_a? Array).should be_true
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

  describe "#destroy" do
    describe "with id" do
      before do
        announcement = Announcement.create( { title: "A Test Title", text: "Some awesome text" } )
        delete :destroy, id: announcement.id.to_s
      end

      it "should redirect to index" do
        response.should redirect_to "/admin/announcements"
      end

      subject { flash[:notice] }
      it { should  =~ /announcement has been removed/i }
    end

    describe "without id" do
      before { delete :destroy, id: '123' }

      subject { flash[:alert] }
      it { should  =~ /problem removing the announcement/i }
    end
  end
end