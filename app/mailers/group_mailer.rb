class GroupMailer < ActionMailer::Base
  default :from => "admin@example.com"
  
  def successful_group_request(user, group)
    @user = user
    @group = group
    mail(:to => user.email,
         :subject => "Your group on SayWhat! is awaiting approval")
    
  end
  
  def admin_pending_group_request(user, group, sponsor)
    @user = user
    @group = group
    @sponsor = sponsor
    mail(:to => user.email,
         :subject => "You have a pending Group Request on SayWhat!")
  end
  
end
