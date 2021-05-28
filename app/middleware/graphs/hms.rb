# frozen_string_literal: true

module Graphs
  class Hms
    def initialize(results)
      @results = results
    end

    def labels
      results.map { |result| result[:period] }
    end

    def datasets
      [ hms, involvement]
    end

    private

    attr_reader :results

    def hms
      {
        label: I18n.t('hmsTrends.hms'),
        data: results.map { |result| result[:hms] },
        yAxisID: I18n.t('hmsTrends.hms'),
        borderColor: 'rgb(91, 33, 182)',
        backgroundColor: 'rgb(196, 181, 253)',
      }
    end

    def involvement
      {
        label: I18n.t('hmsTrends.involvement'),
        data: results.map { |result| result[:involvement] },
        yAxisID: I18n.t('hmsTrends.involvement'),
        borderColor: 'rgb(31, 41, 55)',
        backgroundColor: 'rgb(229, 231, 235)',
      }
    end
  end
end
