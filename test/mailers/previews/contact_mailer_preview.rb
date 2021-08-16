class ContactMailerPreview < ActionMailer::Preview
  def send_email
    ContactMailer.send_email({ name: 'My name', email: 'test@email.com', message: 'Hello from the gutter' })
  end
end
