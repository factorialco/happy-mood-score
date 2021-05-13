module Dashboards
  class Api
    class << self
      def generate(params, company)
        new(params, company).generate
      end
    end

    def initialize(params, company)
      @resource_type = params[:resource_type]
      @resource_id = params[:resource_id]
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @company = company
    end

    def generate
      result = detailed.merge(company_name: company.name)
      result.merge!(team_name: team.name, team_uuid: team.uuid) if team.present?
      result.merge!(employee_name: employee.name, employee_uuid: employee.uuid) if employee.present?

      result
    end

    private

    attr_reader :resource_type, :resource_id, :company

    def entity
      return company if resource_type.blank?

      return team if resource_type == 'team'
      return employee if resource_type == 'employee'
    end

    def detailed
      Votes::Grouped.new(votes).detailed
    end

    def employee
      @employee ||= company.employees.active.find_by(uuid: resource_id)
    end

    def end_date
      return Time.current if @end_date.empty?

      byebug
      Time.parse(@end_date).end_of_day
    rescue
      Time.current
    end

    def start_date
      return 90.days.ago.beginning_of_day if @start_date.empty?

      Date.parse(@start_date).end_of_day
    rescue
      90.days.ago.beginning_of_day
    end

    def team
      @team ||= company.teams.find_by(uuid: resource_id)
    end

    def votes
      entity.votes.where(generated_at: start_date..end_date).group(:result).count
    end
  end
end
