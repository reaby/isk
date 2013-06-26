class Display < ActiveRecord::Base
  
  
  before_save do
    self.metadata_updated_at = Time.now if self.presentation_id_changed?
  end
  
  before_create do
    self.metadata_updated_at = Time.now
  end
  
  belongs_to :presentation
  belongs_to :current_group, :class_name => "MasterGroup"
  belongs_to :current_slide, :class_name => "Slide"
  has_many :override_queues, :order => :position
  
  has_many :display_counts
  
  has_and_belongs_to_many :authorized_users, :class_name => 'User'
  
  
  Timeout = 5 #minutes

  include ModelAuthorization
  
  
  def self.late
    Display.where('monitor = ? AND last_contact_at < ?', true, Timeout.minutes.ago)
  end
  
  def late?
    if self.last_contact_at
      return Time.diff(Time.now, self.last_contact_at,'%m')[:diff].to_i > Timeout
    else
      return false
    end
  end
  
  def uptime
    return nil unless self.last_hello && self.last_contact_at
    
    return Time.diff(self.last_hello, self.last_contact_at, '%h:%m:%s')[:diff]
  end
  
  def to_hash
    h = Hash.new
    h[:metadata_updated_at] = self.metadata_updated_at.to_i
    h[:last_contact_at] = self.last_contact_at.to_i
    h[:updated_at] = self.updated_at.to_i
    h[:created_at] = self.created_at.to_i
    h[:presentation] = self.presentation ? self.presentation.to_hash : Hash.new
    q = Array.new
    self.override_queues.each do |oq|
      q << oq.to_hash
    end
    h[:override_queue] = q
    return h
  end
  

end
