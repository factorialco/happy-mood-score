module Admin
  class NotesController < ::AdminController
    before_action :find_employees, only: :index

    def index
      @notes = Notes::Finder.new(current_employee, params).all
    end

    def create
      @note = current_employee.notes.create(note_params)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend(
            "notes",
            partial: 'admin/notes/note', locals: { note: @note }
          )
        end
        format.html { redirect_to admin_notes_url, notice: I18n.t('todosList.todoCreated') }
      end
    end

    def update
      @note = current_employee.notes.active.find(params[:id])
      @note.update(done: true)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove("note_#{@note.id}")
        end
        format.html { redirect_to admin_notes_url, notice: I18n.t('todosList.todoCreated') }
      end
    end

    private

    def find_employees
      @employees = current_employee.team.employees.active
      if params[:employee_id].present?
        @employees = @employees.where(id: params[:employee_id])
      end

      @employees.order(:name)
    end

    def note_params
      params.require(:note).permit(%i[description receiver_id shared])
    end
  end
end
