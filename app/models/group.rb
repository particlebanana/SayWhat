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
  field :adults_reached_tally, :type => Integer, :default => 0
  field :youth_reached_tally, :type => Integer, :default => 0
  mount_uploader :profile_photo, ProfileUploader
  references_many :users, :dependent => :delete
  embeds_many :projects
  
  attr_accessible :display_name, :city, :organization, :description, :esc_region, :dshs_region, :area, :profile_photo

  validates_presence_of [:name, :display_name, :city, :organization, :status, :esc_region, :dshs_region, :area]
  validates_uniqueness_of [:name]
  
  validates_uniqueness_of [:permalink]
  validates_length_of :permalink, :minimum => 4, :maximum => 20, :allow_nil => true
  
  before_validation :downcase_name
  
  protected
  
    def downcase_name
      if self.display_name
        self.name = self.display_name.downcase
      end
    end
    
  public
  
    def make_slug
      self.permalink = (self.permalink.downcase.gsub(/[^a-zA-Z 0-9]/, "")).gsub(/\s/,'-') if self.permalink
    end
    
    def update_report_tally(adults, youth)
      self.adults_reached_tally += adults.to_i
      self.youth_reached_tally += youth.to_i
    end
    
    # Sends a message to all the members inboxes
    def send_group_message(message_object, author)
      self.users.each do |member|
        message = member.create_message_object(message_object)
        UserMailer.send_message_notification(member, author, message.message_content).deliver
      end
    end

end

