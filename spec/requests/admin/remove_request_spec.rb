require 'rails_helper'

describe 'Admin::RemoveController' do
  let(:admin) { create(:employee, :admin) }
  let(:company) { admin.company }

  before { login_user_request admin.user }

  describe '#show' do
    subject do
      get admin_remove_url
      response
    end

    it { is_expected.to have_http_status :success }
    it { is_expected.to render_template :show }
  end

  describe '#destroy' do
    let(:confirm) { 'delete' }
    let(:params) { { confirm: confirm } }

    subject do
      delete admin_remove_url, params: params
      response
    end


    context 'when confirmation word is valid' do
      let(:confirm) { 'delete' }

      before { expect(DeleteCompanyJob).to receive(:perform_later).with(company.id) }

      it { is_expected.to have_http_status :redirect }
    end

    context 'when confirmation word is invalid' do
      let(:confirm) { 'invalid' }

      before { expect(DeleteCompanyJob).to receive(:perform_later).never }

      it { is_expected.to have_http_status :success }
      it { is_expected.to render_template :show }
    end
  end
end
