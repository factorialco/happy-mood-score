module Api
  module V3
    class NotesController < ApiController
      before_action :find_note, except: %i[index create]

      def index
        @notes = current_employee.notes.page(params[:page]).per(100)
      end

      def show; end

      def create
        @note = current_employee.notes.create(note_params)

        if @note.persisted?
          render partial: 'api/v3/notes/note', locals: { note: @note }
        else
          render json: @note.errors
        end
      end

      def update
        if @note.update(note_params)
          render partial: 'api/v3/notes/note', locals: { note: @note }
        else
          render json: @note.errors
        end
      end

      def destroy
        if @note.destroy
          render json: { deleted: 'ok' }
        else
          render json: @note.errors
        end
      end

      private

      def note_params
        params.permit(:description, :done).merge(receiver: find_receiver)
      end

      def find_note
        @note = current_employee.notes.find_by!(uuid: params[:id])
      end

      def find_receiver
        return if params[:person_id].blank?

        current_company.employees.active.find_by!(uuid: params[:person_id])
      end
    end
  end
end
