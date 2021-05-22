module Main
  class DashboardController < UserController
    before_action :employee

    def index
      @dashboard = Dashboards::Main.generate(employee)
      @employee = employee
      @has_votes = employee.votes.any?
    end

    private

    def employee
      return current_employee unless current_employee.admin?

      @employee ||= current_company.employees.active.find_by(id: params[:id]) || current_employee
    end
  end
end
