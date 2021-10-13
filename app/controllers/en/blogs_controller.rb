module En
  class BlogsController < PublicController
    ENGLISH_CODE = 'en'.freeze

    def index
      @posts = english.posts.order(published_at: :desc).page(params[:page]).per(15)
    end

    def show
      @post = english.posts.find_by(permalink: params[:id])
    end

    private

    def english
      @english ||= Language.find_by(code: ENGLISH_CODE)
    end
  end
end
