class GrantMailer < ActionMailer::Base
  default :from => "no-reply@txsaywhat.com"

  def finalization_notification(host, requestor, group, project, grant)
    @host = host
    @requestor = requestor
    @group = group
    @project = project
    @grant = grant
    mail(to: @group.adult_sponsor.email,
         subject: "You have a new Say What grant application awaiting finalization")
  end

  def grant_approved(grant)
    @grant = grant
    @sponsor = @grant.project.group.adult_sponsor
    mail(:to => @sponsor.email,
         :subject => "Your Say What! Project Grant Has Been Approved")
  end

  def grant_denied(grant, reason)
    @grant = grant
    @sponsor = @grant.project.group.adult_sponsor
    @reason = reason
    mail(:to => @sponsor.email,
         :subject => "Your Say What! Project Grant Has Been Denied")
  end
end