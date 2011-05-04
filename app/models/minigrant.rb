class Grant
  include Mongoid::Document
  include Mongoid::Timestamps
  field :group_name, :type => String
  field :check_payable, :type => String
  field :adult_name, :type => String
  field :adult_phone, :type => String
  field :adult_email, :type => String
  field :adult_address, :type => String
  field :youth_name, :type => String
  field :youth_email, :type => String
  field :project_description, :type => String
  field :project_when, :type => String
  field :project_where, :type => String
  field :project_who, :type => String
  field :project_serve, :type => String
  field :project_goals, :type => String
  field :funds_need, :type => String
  field :community_partnerships, :type => String
  field :community_resources, :type => String
  
  field :status, :type => Boolean, :default => false
  
  validates_presence_of :group_name, :check_payable, :adult_name, :adult_phone, :adult_email, :adult_address, :youth_name, :youth_email, :project_description, :project_when, :project_where, :project_who, :project_serve, :project_goals, :funds_need, :community_partnerships, :community_resources
  
  validates_format_of :adult_email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_format_of :youth_email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  
  
  scope :pending, :where => {:status => false}
  scope :approved, :where => {:status => true}
  
end