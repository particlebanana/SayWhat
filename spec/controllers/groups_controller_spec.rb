require 'spec_helper'

describe GroupsController do
  before { @group = Factory.create(:group) } 

  context "unauthenticated" do
    describe "#index" do
      before { get :index }
    
      it "should return an array of Group objects" do
        assigns[:groups].all.count.should == 1
        (assigns[:groups].all.is_a? Array).should be_true
      end
    
      it "should render the index template" do
        response.should render_template('groups/index')      
      end
    end
  
    describe "#show" do
      before { get :show, id: @group.permalink }
    
      it "should return a Group object" do
        (assigns[:group].is_a? Group).should be_true
      end

      it "should return a Timeline object" do
        assigns[:timeline]['feed'].count.should == 0
      end
        
      it "should render the show template" do
        response.should render_template('groups/show')
      end
    end
  end # / unauthenticated context
 
  context "authenticated" do
   
    context "adult sponsor" do
      before do
        @user = Factory.create(:user, {group: @group, role: 'adult sponsor'})
        sign_in @user
      end
      
      describe "#update" do
        context "with valid input" do
          before { put :update, { id: @group.permalink, group: { display_name: "Rebel Alliance" } } }
      
          subject { @group.reload }
          its(:display_name) { should == "Rebel Alliance" }
          its(:name) { should == "rebel alliance" }
    
          it "should redirect to #show" do
            response.should redirect_to("/groups/#{@group.permalink}")
          end
      
          it "should have a success message" do
            flash[:notice].should =~ /updated successfully/i
          end
        end
    
        context "with invalid input" do
          before { put :update, { id: @group.permalink, group: { display_name: " " } } }
      
          subject{ @group.reload }
          its(:display_name) { should_not == ' ' }
    
          it "should render #edit template" do
            response.should render_template("groups/edit")
          end
        end
      end
      
      describe "#edit" do
        context "adult sponsor" do
          before { get :edit, id: @group.permalink }

          it "should return a Group object" do
            (assigns[:group].is_a? Group).should be_true
          end

          it "should render the show template" do
            response.should render_template('groups/edit')
          end
        end

        # Ensure permissions
        context "member" do
          before do
            sign_out @user
            sign_in Factory.create(:user, { email: 'member@gmail.com' } )
            get :edit, id: @group.permalink
          end

          subject { flash[:alert] }
          it { should  =~ /not authorized to access this page/i }
        end
      end
    end # / adult sponsor context 
  
    context "member" do
      before do
        @user = Factory.create(:user, { email: 'member@gmail.com' } )
        sign_in @user
      end
      
      describe "#new" do
        before { get :new }
          
        it "should return a Group object" do
          (assigns[:group].is_a? Group).should be_true
        end
      
        it "should render the new template" do
          response.should render_template('groups/new')
        end
      end
  
      describe "#create" do 
        before do
          @object = {
            group: {
              display_name: "Create Test", 
              city: "Mos Eisley", 
              organization: "Rebel Alliance", 
              description: "An organization of Vader haters.", 
              permalink: "create-test"
            }
          }
        end
      
        it "should add a group" do
          lambda {
            post :create, @object
          }.should change(Group, "count").by(1)
        end
        
        describe "response" do
          before { post :create, @object }
          
          it "should redirect to /groups" do
            response.should redirect_to('/groups')
          end
        
          it "should include a notice" do
            flash[:notice].should =~ /has been submitted for approval/i
          end
          
          subject { @user.reload }
          its([:group_id]) { should_not be_nil }
        end
      end
    end # / member context
    
  end # / authenticated context
end