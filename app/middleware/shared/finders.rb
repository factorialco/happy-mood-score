# frozen_string_literal: true

module Shared
  module Finders
    private

    def end_date
      @end_date ||= parse_date(params[:end_date])&.end_of_day
    end

    def filter_by_dates
      return filter_by_period if params[:period].present?
      return unless start_date.present? || end_date.present?

      if start_date.present? && end_date.present?
        @results = results.where('activities.created_at': start_date..end_date)
      elsif start_date.present?
        @results = results.where('activities.created_at >= ?', start_date)
      else
        @results = results.where('activities.created_at <= ?', end_date)
      end
    end

    def filter_by_period
      case params[:period].to_s
      when 'month'
        start_date = Time.current.beginning_of_month
        end_date = Time.current.end_of_month
      when 'quarter'
        start_date = Time.current.beginning_of_quarter
        end_date = Time.current.end_of_quarter
      when 'year'
        start_date = Time.current.beginning_of_year
        end_date = Time.current.end_of_year
      else
        start_date = Time.current.beginning_of_week
        end_date = Time.current.end_of_week
      end

      @results = results.where('activities.created_at': start_date..end_date)
    end

    def parse_date(date)
      Date.parse(date)
    rescue
      nil
    end

    def start_date
      @start_date ||= parse_date(params[:start_date])&.beginning_of_day
    end
  end
end
