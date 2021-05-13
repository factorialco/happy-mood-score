# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API Company' do
  describe '#index' do
    let(:token) { employee.api_key }
    let(:employee) { create(:employee, :manager) }
    let(:company) { employee.company }
    let(:team) { company.teams.first }
    let(:dashboard_info) { JSON.parse(response.body) }
    let(:resource_type) {}
    let(:resource_id) {}
    let(:start_date) {}
    let(:end_date) {}
    let(:params) { { resource_type: resource_type, resource_id: resource_id, start_date: start_date, end_date: end_date } }

    subject do
      get '/api/v3/dashboard', params: params, headers: { 'ACCEPT' => 'application/json', 'Authorization' => "Bearer #{token}" }
      response
    end

    it_behaves_like 'invalid token'

    it_behaves_like 'employee not manager'

    it { is_expected.to have_http_status :success }

    context 'when request type is not present' do
      it { is_expected.to have_http_status :success }
      it { subject; expect(dashboard_info).to include({ "companyName" => company.name }) }
      it { subject; expect(dashboard_info).to_not include({ "teamName" => employee.team.name }) }
      it { subject; expect(dashboard_info).to_not include({ "employeeName" => employee.name }) }
    end

    context 'when request team is present' do
      let(:resource_type) { 'team' }
      let(:resource_id) { team.uuid }

      it { is_expected.to have_http_status :success }
      it { subject; expect(dashboard_info).to include({ "companyName" => company.name }) }
      it { subject; expect(dashboard_info).to include({ "teamName" => team.name }) }
      it { subject; expect(dashboard_info).to_not include({ "employeeName" => employee.name }) }
    end

    context 'when request employee is present' do
      let(:resource_type) { 'employee' }
      let(:resource_id) { employee.uuid }

      it { is_expected.to have_http_status :success }
      it { subject; expect(dashboard_info).to include({ "companyName" => company.name }) }
      it { subject; expect(dashboard_info).to_not include({ "teamName" => team.name }) }
      it { subject; expect(dashboard_info).to include({ "employeeName" => employee.name }) }
    end
  end
end

