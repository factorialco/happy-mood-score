module Es
  class ContactController < BaseController
    def index; end

    def create
      if valid_params?
        ContactMailer.send_email(contact_info).deliver_later

        flash.now['notice'] = I18n.t('contact.messageReceived')
      end

      render 'index'
    end

    private

    def valid_params?
      name.present? && email.present? && message.present?
    end

    def name
      params[:name]
    end

    def email
      params[:email]
    end

    def message
      params[:message]
    end

    def contact_info
      { name: name, email: email, message: message }
    end
  end
end
