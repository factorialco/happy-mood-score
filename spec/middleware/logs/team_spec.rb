require 'rails_helper'

RSpec.describe Logs::Team do
  describe '.update' do
    let(:company) { create(:company) }
    let(:team) { company.teams.first }
    let(:employee) { team.employees.first }
    let(:other_employee) { create(:employee, company: company) }
    let(:wednesday) { Time.current.prev_occurring(:wednesday) }
    let(:start_date) { wednesday.beginning_of_week }
    let(:end_date) { wednesday.end_of_week }
    let(:tuesday) { start_date.next_occurring(:tuesday) }
    let(:high5) { company.events.high5.first }

    before do
      create_list(:vote, 4, :voted, result: 20, team: team, generated_at: tuesday)
      create_list(:vote, 2, :voted, result: 30, team: team, generated_at: wednesday, description: 'something said')
      create(:vote, :voted, result: 10, team: team, generated_at: tuesday)
      create_list(:vote, 3, team: team, generated_at: wednesday)
      create_list(:vote, 2, team: team, generated_at: 4.months.ago)
      create_list(:activity, 2, event: high5, sender: employee, created_at: wednesday)
      create_list(:activity, 3, event: high5, sender: other_employee, employee: employee, created_at: tuesday)

      described_class.update(start_date, end_date, team)
    end

    subject { team.historical_logs.last }

    its(:total_votes) { is_expected.to eql 7 }
    its(:total_count) { is_expected.to eql 10 }
    its(:total_pending) { is_expected.to eql 3 }
    its(:results_bad) { is_expected.to eql 1 }
    its(:results_fine) { is_expected.to eql 4 }
    its(:results_good) { is_expected.to eql 2 }
    its(:comments) { is_expected.to eql 2 }
    its(:feedback_given) { is_expected.to eql 7 }
    its(:high5_given) { is_expected.to eql 2 }
    its(:high5_received) { is_expected.to eql 3 }
    its(:hms) { is_expected.to eql team.hms }
    its(:involvement) { is_expected.to eql team.involvement }
  end
end
