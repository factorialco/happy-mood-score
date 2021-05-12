module Api
  module V3
    class NextVoteController < ApiController
      before_action :find_vote_by_employee

      def show; end

      private

      def find_vote_by_employee
        if current_employee.manager?
          @vote = current_company.employees.active.find_by!(uuid: params[:id]).votes.last_request
        else
          @vote = current_employee.votes.last_request
        end
      end
    end
  end
end
