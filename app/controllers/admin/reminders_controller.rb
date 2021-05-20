module Admin
  class RemindersController < ::AdminController
    before_action :find_vote

    def create
      current_employee.notes.create!(description: params[:description], receiver: @vote.employee)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to admin_feedback_index_url, notice: I18n.t('feedbackList.sentOk') }
      end
    end

    private

    def find_vote
      @vote = current_company.votes.voted.find(params[:feedback_id])
    end
  end
end
