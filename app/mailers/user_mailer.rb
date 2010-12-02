class UserMailer < ActionMailer::Base
  default :from => "admin@example.com"
  
  # Sends an email to the pending member that they successfully submiited a membership request
  def successful_membership_request(user, group)
    @user = user
    @group = group
    mail(:to => user.email,
         :subject => "Your membership to #{@group.display_name} on SayWhat! is awaiting approval")
    
  end
  
  # Sends a pending membership notice to the group sponsors
  def sponsor_pending_membership_request(user, group, member)
    @user = user
    @group = group
    @member = member
    mail(:to => user.email,
         :subject => "You have a pending membership request on SayWhat!")
  end
  
  # Sends an email to a pending member that they have been approved
  def send_approved_notice(user, group, url)
    @user = user
    @group = group
    @url = "http://" + url + "/setup/member?auth_token=" + user.authentication_token
    mail(:to => user.email,
         :subject => "You have been approved for membership on SayWhat!")
  end
  
  # Sends an email notification of youth sponsorship promotion
  def send_sponsor_promotion(user, group)
    @user = user
    @group = group
    mail(:to => user.email,
         :subject => "You have been promoted to a sponsor for the group #{group.display_name} on SayWhat!")
  end
  
end
