module Admin
  class RemovesController < ::AdminController
    DELETE_CONFIRMATION = %w(delete borrar)

    before_action :find_company

    def show; end

    def destroy
      if params[:confirm].downcase.presence_in(DELETE_CONFIRMATION)
        DeleteCompanyJob.perform_later(current_company.id)
        logout

        redirect_to root_url, notice: I18n.t('dashboardOnboardAdmin.bye')
      else
        @error = true
        render 'show'
      end
    end

    private

    def find_company
      @company = current_user.company
    end
  end
end
