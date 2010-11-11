class GroupMailer < ActionMailer::Base
  default :from => "admin@example.com"
  
  # Sends an email to a pending group's adult sponsor
  def successful_group_request(user, group)
    @user = user
    @group = group
    mail(:to => user.email,
         :subject => "Your group on SayWhat! is awaiting approval")
    
  end
  
  # Sends a pending group notice to the site admins
  def admin_pending_group_request(user, group, sponsor)
    @user = user
    @group = group
    @sponsor = sponsor
    mail(:to => user.email,
         :subject => "You have a pending Group Request on SayWhat!")
  end
  
  # Sends a link to an approved group's sponsor to begin the setup process
  def send_approved_notice(user, group, url)
    @user = user
    @group = group
    @url = "http://" + url + "/setup?auth_token=" + user.authentication_token
    mail(:to => user.email,
         :subject => "Your group has been approved on SayWhat!")
  end
  
end
