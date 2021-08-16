require 'rails_helper'

RSpec.describe 'Main::Contacts', type: :request do
  let(:company) { create(:company) }
  let(:employee) { create(:employee, company: company) }
  let(:user) { employee.user }

  before { login_user_request user }

  describe '#index' do
    subject do
      get new_main_contact_url
      response
    end

    context 'when request is valid' do
      it { is_expected.to have_http_status :success }

      it { is_expected.to render_template :new }
    end
  end

  describe '#post' do
    let(:params) { {} }

    subject do
      post main_contacts_url, params: params
      response
    end

    context 'when message is empty' do
      let(:params) { { message: '' } }

      it { is_expected.to have_http_status :success }

      it { is_expected.to render_template :new }
    end

    context 'when message is valid' do
      let(:params) { { message: 'Circe poisoning the sea' } }

      it { is_expected.to have_http_status :redirect }

      context 'email job' do
        let(:user_name) { "#{employee.name} - #{user.company.name}" }
        let(:user_email) { user.email }
        let(:contact_params) do
          {
            name: user_name,
            email: user_email,
            message: params[:message]
          }
        end
        let(:contact_mailer) { ContactMailer.send_email(contact_params) }

        it 'should deliver the email' do
          expect(ContactMailer).to receive(:send_email).with(contact_params).and_return(contact_mailer)

          subject
        end
      end
    end
  end
end
