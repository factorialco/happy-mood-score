module Main
  class NotesController < ::UserController
    before_action :find_employee, only: :index

    def index
      @notes = note_list
    end

    def create
      @note = current_employee.notes.create(note_params)

      if @note.valid?
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.prepend(
              "notes",
              partial: 'main/notes/note', locals: { note: @note }
            )
          end
          format.html { redirect_to main_notes_url, notice: I18n.t('todosList.todoCreated') }
        end
      end
    end

    def update
      @note = current_employee.notes.active.find(params[:id])
      @note.update(done: true)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove("note_#{@note.id}")
        end
        format.html { redirect_to main_notes_url, notice: I18n.t('todosList.todoCreated') }
      end
    end

    private

    def find_employee
      return if params[:employee_id].blank?

      @employee = current_company.employees.active.find_by(id: params[:employee_id])
    end

    def note_list
      params[:closed].to_i == 1 ? current_employee.notes.closed : current_employee.notes.active
    end

    def note_params
      params.require(:note).permit(%i[description])
    end
  end
end
