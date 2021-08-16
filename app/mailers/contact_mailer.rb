class ContactMailer < ApplicationMailer
  def send_email(info)
    @info = info
    mail(to: HMS_CONTACT_EMAIL, subject: "Contact company: #{info[:name]}")
  end
end
