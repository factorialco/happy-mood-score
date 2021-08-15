require 'rails_helper'

describe 'Es::Features' do
  describe '#index' do
    subject do
      get es_caracteristicas_url
      response
    end

    it { is_expected.to have_http_status :success }
  end
end
