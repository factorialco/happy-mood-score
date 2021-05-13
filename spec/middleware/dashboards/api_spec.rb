require 'rails_helper'

RSpec.describe Dashboards::Api do
  let(:company) { create(:company) }
  let(:team) { create(:team, company: company) }
  let(:employee) { create(:employee, company: company) }
  let(:params) { { resource_type: resource_type, resource_id: resource_id, start_date: start_date, end_date: end_date } }

  before do
    create_list(:vote, 3, :voted, result: 10, company: company, generated_at: 3.weeks.ago)
    create_list(:vote, 2, :voted, result: 20, team: team, company: company, generated_at: 4.days.ago)
    create_list(:vote, 1, :voted, result: 30, employee: employee, company: company, generated_at: 2.months.ago)
    create_list(:vote, 5, company: company, employee: employee, generated_at: 5.months.ago)
  end

  context 'when no params are present' do
    let(:resource_type) {}
    let(:resource_id) {}
    let(:start_date) {}
    let(:end_date) {}

    subject { described_class.generate(params, company) }

    its([:total_bad]) { is_expected.to eql 3 }
    its([:total_good]) { is_expected.to eql 1 }
    its([:total_fine]) { is_expected.to eql 2 }
    its([:total_votes]) { is_expected.to eql 6 }
    its([:total_count]) { is_expected.to eql 6 }
    its([:total_pending]) { is_expected.to eql 0 }
    its([:involvement]) { is_expected.to eql 100 }
    its([:hms]) { is_expected.to eql -2 }
    its([:company_name]) { is_expected.to eql company.name }
  end

  context 'when a team resource is present' do
    let(:resource_type) { 'team' }
    let(:resource_id) { team.uuid }
    let(:start_date) {}
    let(:end_date) {}

    subject { described_class.generate(params, company) }

    its([:total_bad]) { is_expected.to eql 0 }
    its([:total_good]) { is_expected.to eql 0 }
    its([:total_fine]) { is_expected.to eql 2 }
    its([:total_votes]) { is_expected.to eql 2 }
    its([:total_count]) { is_expected.to eql 2 }
    its([:total_pending]) { is_expected.to eql 0 }
    its([:involvement]) { is_expected.to eql 100 }
    its([:hms]) { is_expected.to eql 5 }
    its([:company_name]) { is_expected.to eql company.name }
  end

  context 'when an employee resource is present' do
    let(:resource_type) { 'employee' }
    let(:resource_id) { employee.uuid }
    let(:start_date) {}
    let(:end_date) {}

    subject { described_class.generate(params, company) }

    its([:total_bad]) { is_expected.to eql 0 }
    its([:total_good]) { is_expected.to eql 1 }
    its([:total_fine]) { is_expected.to eql 0 }
    its([:total_votes]) { is_expected.to eql 1 }
    its([:total_count]) { is_expected.to eql 1 }
    its([:total_pending]) { is_expected.to eql 0 }
    its([:involvement]) { is_expected.to eql 100 }
    its([:hms]) { is_expected.to eql 10 }
    its([:company_name]) { is_expected.to eql company.name }
  end

  context 'when dates are present' do
    let(:resource_type) { 'employee' }
    let(:resource_id) { employee.uuid }
    let(:start_date) { 6.months.ago.strftime('%Y-%m-%d') }
    let(:end_date) {}

    subject { described_class.generate(params, company) }

    its([:total_bad]) { is_expected.to eql 0 }
    its([:total_good]) { is_expected.to eql 1 }
    its([:total_fine]) { is_expected.to eql 0 }
    its([:total_votes]) { is_expected.to eql 1 }
    its([:total_count]) { is_expected.to eql 6 }
    its([:total_pending]) { is_expected.to eql 5 }
    its([:involvement]) { is_expected.to eql 17 }
    its([:hms]) { is_expected.to eql 10 }
    its([:company_name]) { is_expected.to eql company.name }
  end
end
