class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name
  field :display_name
  field :city
  field :organization
  field :description
  field :permalink
  field :status
  field :esc_region, :default => 'pending'
  field :dshs_region, :default => 'pending'
  field :area, :default => 'pending'
  mount_uploader :profile_photo, ProfileUploader
  references_many :users, :dependent => :delete
  embeds_many :projects
  
  attr_accessible :display_name, :city, :organization, :description, :esc_region, :dshs_region, :area, :profile_photo

  validates_presence_of [:name, :display_name, :city, :organization, :status, :esc_region, :dshs_region, :area]
  validates_uniqueness_of [:name]
  
  validates_uniqueness_of [:permalink]
  validates_length_of :permalink, :minimum => 4, :maximum => 20, :allow_nil => true
  
  before_validation :downcase_name
  
  before_save :downcase_area
  
  protected
  
    def downcase_name
      if self.display_name
        self.name = self.display_name.downcase
      end
    end
    
    def downcase_area
      area.downcase!
    end

end

