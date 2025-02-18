class ApplicationController < ActionController::Base
  before_action :set_locale

  rescue_from ActiveRecord::RecordNotFound do
    render nothing: true, status: :not_found
  end

  private

  def default_locale
    lang_from_params || current_user&.language&.code || 'en'
  end

  def lang_from_params
    return if params[:lang].blank?

    available_languages = Language.all.pluck(:code)
    available_languages.include?(params[:lang].to_s) ? params[:lang].to_s : 'en'
  end

  def set_locale
    I18n.locale = default_locale
  end
end
