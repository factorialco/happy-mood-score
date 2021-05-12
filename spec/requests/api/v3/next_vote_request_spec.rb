# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API Next Vote' do
  let(:login) { create(:employee, :manager) }
  let(:token) { login.api_key }
  let(:company) { login.company }
  let(:headers) { { 'ACCEPT' => 'application/json', 'Authorization' => "Bearer #{token}" } }

  describe '#show' do
    let!(:login_vote) { create(:vote, employee: login, company: company) }
    let(:vote) { create(:vote, company: company) }
    let(:employee_id) { vote.employee.uuid }
    let(:vote_info) { JSON.parse(response.body) }

    subject do
      get "/api/v3/next_vote/#{employee_id}", headers: headers
      response
    end

    it_behaves_like 'invalid token'

    context 'when user is manager' do
      it { is_expected.to have_http_status :success }

      it { subject; expect(vote_info).to include("employeeId" => vote.employee.uuid) }
      it { subject; expect(vote_info).to include("token" => vote.token) }
    end

    context 'when user is not a manager' do
      let(:token) { vote.employee.api_key }
      let(:employee_id) { login.uuid }

      it { is_expected.to have_http_status :success }

      it { subject; expect(vote_info).to_not include("employeeId" => login.uuid) }
      it { subject; expect(vote_info).to include("employeeId" => vote.employee.uuid) }
      it { subject; expect(vote_info).to include("token" => vote.token) }
    end
  end
end

