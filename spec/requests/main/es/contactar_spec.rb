require 'rails_helper'

RSpec.describe 'Es::Contactar', type: :request do
  describe '#index' do
    subject do
      get es_contactar_url
      response
    end

    context 'when request is valid' do
      it { is_expected.to have_http_status :success }

      it { is_expected.to render_template :index }
    end
  end

  describe '#post' do
    let(:params) { {} }

    subject do
      post es_contactar_url, params: params
      response
    end

    context 'when message is empty' do
      let(:params) { { message: 'The shadow over Innsmouth' } }

      it { is_expected.to have_http_status :success }

      it { is_expected.to render_template :index }
    end

    context 'when message is valid' do
      let(:params) do
        {
          name: 'Lovecraft',
          email: 'hp@lovecraft.name',
          message: 'The shadow over Innsmouth'
        }
      end

      it { is_expected.to have_http_status :success }

      context 'email job' do
        let(:contact_params) do
          {
            name: params[:name],
            email: params[:email],
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
