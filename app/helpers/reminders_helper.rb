module RemindersHelper

  def format_delivery(email)
    match = /(\d.*)@/.match(email)
    number = match[1] if match
    if number
      number_to_phone(number)
    else
      email
    end
  end

end
