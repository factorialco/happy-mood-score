module Es
  class BaseController < PublicController
    before_action :set_language

    private

    def set_language
      I18n.locale = 'es'
    end
  end
end
