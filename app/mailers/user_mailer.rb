class UserMailer < ActionMailer::Base
  default :from => "no-reply@txsaywhat.com"
  
  # Sends an email to the pending member that they successfully submiited a membership request
  def successful_membership_request(user, group)
    @user = user
    @group = group
    mail(:to => user.email,
         :subject => "Your membership to #{@group.display_name} on SayWhat! is awaiting approval")
    
  end
  
  # Sends a pending membership notice to the group sponsors
  def sponsor_pending_membership_request(sponsor, group, user)
    @sponsor = sponsor
    @group = group
    @user = user
    mail(:to => @sponsor.email,
         :subject => "You have a pending membership request on SayWhat!")
  end
  
  # Sends an email to a pending member that they have been approved
  def send_approved_notice(user, group)
    @user = user
    @group = group
    @url = "http://txsaywhat.com/groups/#{@group.permalink}"
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
  
  # Sends an email notification of youth sponsorship revocation
  def send_sponsor_revocation(user, group)
    @user = user
    @group = group
    mail(:to => user.email,
         :subject => "You have been demoted from sponsor for the group #{group.display_name} on SayWhat!")
  end
end