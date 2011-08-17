class Group < ActiveRecord::Base
  
  mount_uploader :profile_photo, ProfileUploader

  #has_many :users, :dependent => :delete, autosave: true
  #embeds_many :projects
  
  attr_accessible :display_name, :city, :organization, :description, :permalink, :esc_region, :dshs_region, :area, :profile_photo

  validates_presence_of [:name, :display_name, :city, :organization, :permalink, :status, :esc_region, :dshs_region, :area]
  validates_uniqueness_of [:name]
  
  validates_uniqueness_of [:permalink]
  validates_length_of :permalink, :minimum => 4, :maximum => 20, :allow_nil => true
  
  before_validation :downcase_name
  after_validation :sanitize
  
  protected
  
    def downcase_name
      if self.display_name
        self.name = self.display_name.downcase
      end
    end
    
    def sanitize
      self.description = Sanitize.clean(self.description, Sanitize::Config::RESTRICTED) if self.description
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
    
    # Reassign a group sponsor to another group member
    def reassign_sponsor(user_id)
      current_sponsor = self.users.adult_sponsor.first
      proposed_sponsor = self.users.find(user_id)
      if current_sponsor && proposed_sponsor
        current_sponsor.change_role_level("member")
        proposed_sponsor.change_role_level("adult sponsor")
      end
    end

end