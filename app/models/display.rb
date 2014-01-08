# ISK - A web controllable slideshow system
#
# Author::    Vesa-Pekka Palmu
# Copyright:: Copyright (c) 2012-2013 Vesa-Pekka Palmu
# License::   Licensed under GPL v3, see LICENSE.md


class Display < ActiveRecord::Base
  
  
  before_save do
    self.metadata_updated_at = Time.now if self.presentation_id_changed?
		if self.manual
			self.do_overrides = false
		end
		return true
  end
  
  before_create do
    self.metadata_updated_at = Time.now
  end
  
  belongs_to :presentation
  belongs_to :current_group, :class_name => "Group"
  belongs_to :current_slide, :class_name => "Slide"
  has_many :override_queues, :order => :position
  has_many :display_counts
  has_and_belongs_to_many :authorized_users, :class_name => 'User'
  
  validates :name, :uniqueness => true, :presence => true, :length => { :maximum => 50 }
  validates :ip, :length => { :maximum => 12 }
  validates :monitor, :manual, :inclusion => { :in => [true, false] }
  validates :websocket_connection_id, :presentation_id, :current_slide_id, :current_group_id, :numericality => {:only_integer => true}, :allow_nil => true
  
  
  
  Timeout = 5 #minutes

  include ModelAuthorization
  
  attr_accessible :name, :presentation_id, :monitor, :manual, :do_overrides
  
  def websocket_channel
    return "display_" + self.id.to_s
  end
  
  def displays
    return [self]
  end
  
  def add_to_override(slide, duration)
    oq = self.override_queues.new
    oq.duration = duration
    oq.slide = slide
		self.metadata_updated_at = Time.now
		self.save!
    oq.save!
  end
  
  def self.hello(display_name, display_ip, connection_id = nil)
    display = Display.where(:name => display_name).first_or_initialize
    display.ip = display_ip
    display.websocket_connection_id = connection_id 
    display.last_contact_at = Time.now
    display.last_hello = Time.now
    display.save!
    return display
  end
  
  def override_shown(override_id, connection_id = nil)
    oq = self.override_queues.find(override_id)
    self.last_contact_at = Time.now
		self.websocket_connection_id = connection_id
    oq.destroy
  end
  
  def set_current_slide(group_id, slide_id, connection_id = nil)
    if group_id != -1
      self.current_group = self.presentation.groups.find(group_id)
    else
      self.current_group_id = -1
    end
    s = Slide.find(slide_id)
    self.current_slide = s
    self.last_contact_at = Time.now
		self.websocket_connection_id = connection_id
    s.shown_on(self.id)
    
  end

  
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
    h[:id] = self.id
    h[:name] = self.name
    h[:last_contact_at] = self.last_contact_at.to_i
    h[:updated_at] = self.updated_at.to_i
    h[:manual] = self.manual
    h[:current_slide_id] = self.current_slide_id
    h[:current_group_id] = self.current_group_id
    h[:created_at] = self.created_at.to_i
    h[:presentation] = self.presentation ? self.presentation.to_hash : Hash.new
    q = Array.new
		if self.do_overrides
			self.override_queues.each do |oq|
      	q << oq.to_hash
    	end
		end
		h[:override_queue] = q
    return h
  end
  

end
