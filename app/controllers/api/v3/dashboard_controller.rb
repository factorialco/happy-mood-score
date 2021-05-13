module Api
  module V3
    class DashboardController < ApiManagerController
      def show
        @dashboard = Dashboards::Api.generate(api_params, current_company)
        @resource_type = params[:resource_type]
      end

      private

      def api_params
        params.permit(%i[resource_type resource_id start_date end_date])
      end
    end
  end
end
