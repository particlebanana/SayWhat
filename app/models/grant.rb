class Grant < ActiveRecord::Base

  belongs_to :project

  attr_protected :member

  validates_presence_of [:member, :planning_team, :serviced, :goals, :funds_use, :partnerships, :resources]
end