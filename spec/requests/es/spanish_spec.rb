require 'rails_helper'

describe 'Es::Home' do
  describe '#index' do
    subject do
      get es_url
      response
    end

    it { is_expected.to have_http_status :success }
  end
end
