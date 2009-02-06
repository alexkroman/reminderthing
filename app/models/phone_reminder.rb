class PhoneReminder < Reminder
  include SMSFu
  include ActionView::Helpers::NumberHelper

  attr_accessor :normalized_phone_number 
  before_validation_on_create :set_phone_number, :set_email

  def deliver_to_format
    number_to_phone(phone_number)
  end

  private

  def carrier
    Block.find_carrier(phone_number)
  end

  def set_email
    self.email = get_sms_address(self.phone_number, carrier) 
  end

  def set_phone_number
    self.phone_number = self.deliver_to.gsub(/\D/,'')
  end

end
