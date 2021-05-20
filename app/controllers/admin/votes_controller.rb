module Admin
  class VotesController < AdminController
    def index
      @votes = Feedback::Finder.new(current_employee, params.merge(team_id: current_employee.team.id)).all
    end
  end
end
