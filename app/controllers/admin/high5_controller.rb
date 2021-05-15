module Admin
  class High5Controller < AdminController
    def index
      @employees = employees_list.all
    end

    def show
      @employee = current_company.employees.find(params[:id])
      @high5s = High5::Finder.new(current_company, find_params.merge(receiver_id: @employee.id)).all
    end

    def search
      @employees = employees_list.all

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('employees-list', partial: 'admin/high5/employee', collection: @employees)
        end

        format.html { redirect_to admin_employees_url }
      end
    end

    private

    def employees_list
      Employees::Finder.new(current_company, params)
    end

    def find_params
      params.permit(:period)
    end
  end
end
