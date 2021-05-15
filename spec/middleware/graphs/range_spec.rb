require 'rails_helper'

RSpec.describe Graphs::Range do
  let(:company) { create(:company) }
  let(:start_date) { Time.current.beginning_of_month }
  let(:end_date) { Time.current.end_of_month }
  let(:range) { described_class.new(company, start_date, end_date) }
  let(:result) do
    {
      hms: 3,
      involvement: 64,
      total_bad: 2,
      total_fine: 4,
      total_good: 3,
      period: (I18n.t('date.month_names'))[start_date.month]
    }
  end

  before do
    5.times { create(:vote, company: company, generated_at: rand(start_date..end_date)) }
    2.times { create(:vote, result: 10, company: company, generated_at: rand(start_date..end_date)) }
    3.times { create(:vote, result: 30, company: company, generated_at: rand(start_date..end_date)) }
    4.times { create(:vote, result: 20, company: company, generated_at: rand(start_date..end_date)) }
    2.times { create(:vote, :voted, company: company, generated_at: 3.months.ago) }
  end

  describe '.by_month' do
    let(:result) do
      {
        hms: 3,
        involvement: 64,
        total_bad: 2,
        total_fine: 4,
        total_good: 3,
        period: (I18n.t('date.month_names'))[start_date.month]
      }
    end

    subject { range.by_month }

    it { is_expected.to eql result }
  end

  describe '.by_week' do
    let(:start_date) { Time.current.beginning_of_month }
    let(:end_date) { Time.current.end_of_month }
    let(:result) do
      {
        hms: 3,
        involvement: 64,
        total_bad: 2,
        total_fine: 4,
        total_good: 3,
        period: "#{(I18n.t('date.month_names'))[start_date.month]} 01"
      }
    end

    subject { range.by_week }

    it { is_expected.to eql result }
  end
end
