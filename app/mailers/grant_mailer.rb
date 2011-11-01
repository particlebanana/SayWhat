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
end