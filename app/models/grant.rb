class Grant < ActiveRecord::Base

  belongs_to :project

  attr_protected :member

  validates_presence_of [:member, :check_payable, :mailing_address, :phone, :planning_team,
    :serviced, :goals, :funds_use, :partnerships, :resources]
end