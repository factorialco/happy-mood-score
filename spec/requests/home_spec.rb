require 'rails_helper'

describe 'Home' do
  describe '#index' do
    subject do
      get root_url
      response
    end

    it { is_expected.to have_http_status :success }
  end
end
