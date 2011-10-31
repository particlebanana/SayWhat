class Grant < ActiveRecord::Base

  belongs_to :project

  attr_protected [:member, :status]

  validates_presence_of [:status, :member, :planning_team, :serviced, :goals, :funds_use, :partnerships, :resources]

  def create_grant_application
    if self.save!
      # send email to adult sponsor notifiying of grant applicatiion
      # unless user is an adult sponsor
      return true
    else
      return false
    end
  end

end