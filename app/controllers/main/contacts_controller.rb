module Main
  class ContactsController < UserController
    def new; end

    def create
      if params[:message].present?
        ContactMailer.send_email(contact_params).deliver_later

        redirect_to main_dashboard_index_url, notice: I18n.t('contact.messageReceived')
      else
        render 'new'
      end
    end

    private

    def contact_params
      {
        name: "#{current_user.employee.name} - #{current_user.company.name}",
        email: current_user.email,
        message: params[:message]
      }
    end
  end
end
