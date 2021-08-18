require 'rails_helper'

describe 'En::Blog' do
  let!(:post) { create(:post) }

  describe '#index' do
    subject do
      get blogs_url
      response
    end

    it { is_expected.to have_http_status :success }
  end

  describe '#show' do
    subject do
      get blog_url(post.permalink)
      response
    end

    it { is_expected.to have_http_status :success }
  end
end
