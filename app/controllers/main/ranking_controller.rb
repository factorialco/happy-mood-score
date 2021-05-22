module Main
  class RankingController < ::UserController
    before_action :employee

    def show
      @trends = Ranking::Trends.generate(employee)
      @employee = employee
    end

    private

    def employee
      return current_employee unless current_employee.admin?

      @employee ||= current_company.employees.active.find_by(id: params[:id]) || current_employee
    end
  end
end

