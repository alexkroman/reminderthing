class Reminder < ActiveRecord::Base
  include SMSFu
  attr_accessor :normalized_phone_number, :phone_number, :send_at_date, :send_at_time, :time_zone

  belongs_to :user

  before_validation_on_create :set_email_if_email, :normalize_phone_number, :set_email, :set_send_at
  validate :validate_email, :validate_send_at
  validates_presence_of :message, :message => 'needs to have something in it'
  validates_presence_of :send_at

  def send_at_text
   "#{self.send_at_date} #{self.send_at_time}"
  end

  def send_at_time_display
    send_at.strftime('%I:%M%p')
  end
  
  def send_at_date_display
    if send_at.to_date == Date.today
      output = 'Today'
    elsif send_at.to_date == Date.today + 1
      output = 'Tomorrow'
    else
      send_at.strftime('%a, %b %d') 
    end
  end

  def sent!
    self.sent = true
    self.save!
  end

  def self.find_not_sent
    find_all_by_sent(false, :conditions => ['send_at < ?', Time.now.utc])
  end

  def self.find_guest(session_id)
    Reminder.find(:all,
                  :conditions => ['send_at >= ? AND session_id = ?', Time.now.midnight.utc, session_id],
                  :order => 'send_at ASC')
  end

  def self.find_owned(user)
    Reminder.find(:all,
                  :conditions => ['send_at >= ? AND user_id = ?', Time.now.midnight.utc, user.id],
                  :order => 'send_at ASC')
  end

  private

  def carrier
    Block.find_carrier(normalized_phone_number)
  end

  def validate_email
    errors.add(:phone_number, ' is not currently supported') unless self.email
  end

  def validate_send_at
    errors.add(:send_at_date, ' is not valid') unless self.send_at
    errors.add(:send_at_time, ' is not valid') unless self.send_at
  end

  def set_email_if_email
    self.email = self.phone_number if self.phone_number.match('@')
  end

  def set_email
    self.email = get_sms_address(self.normalized_phone_number, carrier) unless self.email
  rescue
    nil
  end

  def set_send_at
    self.send_at = Time.parse(send_at_text)
  rescue
    nil
  end

  def normalize_phone_number
    self.normalized_phone_number = self.phone_number.gsub(/\D/,'')
  end
  
end
