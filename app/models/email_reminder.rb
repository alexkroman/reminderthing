class EmailReminder < Reminder
  before_validation_on_create :set_email

  def deliver_to_format
    self.email
  end

  private

  def set_email
    self.email = self.deliver_to
  end

end
