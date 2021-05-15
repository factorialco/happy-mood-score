require 'rails_helper'

RSpec.describe 'API 1on1' do
  let(:employee) { create(:employee, :manager) }
  let(:token) { employee.api_key }
  let(:company) { employee.company }
  let(:receiver) { create(:employee, company: company) }
  let!(:notes) { create_list(:note, 3, employee: employee) }
  let!(:other_note) { create(:note) }
  let(:name) {}
  let(:headers) { { 'ACCEPT' => 'application/json', 'Authorization' => "Bearer #{token}" } }

  describe '#index' do
    let(:notes_list) { JSON.parse(response.body) }

    subject do
      get '/api/v3/1on1', headers: headers
      response
    end

    it_behaves_like 'invalid token'

    it { is_expected.to have_http_status :success }

    context 'json content' do
      before { subject }

      it { expect(notes_list).to include(a_hash_including({ 'id' => notes[0].uuid })) }
      it { expect(notes_list).to include(a_hash_including({ 'id' => notes[1].uuid })) }
      it { expect(notes_list).to include(a_hash_including({ 'id' => notes[2].uuid })) }
      it { expect(notes_list).to_not include(a_hash_including({ 'id' => other_note.uuid })) }
    end
  end

  describe '#show' do
    let(:note) { create(:note, employee: employee, receiver: receiver) }

    subject do
      get "/api/v3/1on1/#{note.uuid}", headers: headers
      response
    end

    it_behaves_like 'invalid token'

    it { is_expected.to have_http_status :success }

    context 'when note has a receiver' do
      let(:note_info) { JSON.parse(response.body) }

      before { subject }

      it { expect(note_info).to include({ 'id' => note.uuid }) }
      it { expect(note_info).to include({ 'description' => note.description }) }
      it { expect(note_info).to include({ 'personId' => note.receiver.uuid }) }
      it { expect(note_info).to include({ 'personName' => note.receiver.name }) }
    end

    context 'when note does not have a receiver' do
      let(:note) { create(:note, employee: employee, receiver: nil) }
      let(:note_info) { JSON.parse(response.body) }

      before { subject }

      it { expect(note_info).to include({ 'id' => note.uuid }) }
      it { expect(note_info).to include({ 'description' => note.description }) }
      it { expect(note_info).to_not include({ 'personId' => note.receiver.uuid }) }
      it { expect(note_info).to_not include({ 'personName' => note.receiver.name }) }
    end
  end

  describe '#create' do
    let(:params) { { description: description, person_id: person_id } }
    let(:note_info) { JSON.parse(response.body) }
    let(:description) { 'New note' }
    let(:person_id) {}

    subject do
      post '/api/v3/1on1', params: params, headers: headers
      response
    end

    it_behaves_like 'invalid token'

    it { is_expected.to have_http_status :success }

    context 'when data includes a receiver' do
      let(:person_id) { receiver.uuid }
      let(:new_note) { employee.notes.last }

      before { subject }

      it { expect(note_info).to include({ 'id' => new_note.uuid }) }
      it { expect(note_info).to include({ 'description' => new_note.description }) }
      it { expect(note_info).to include({ 'employeeId' => new_note.employee.uuid }) }
      it { expect(note_info).to include({ 'personId' => new_note.receiver.uuid }) }
    end

    context 'when data does not include a receiver' do
      let(:new_note) { employee.notes.last }

      before { subject }

      it { expect(note_info).to include({ 'id' => new_note.uuid }) }
      it { expect(note_info).to include({ 'description' => new_note.description }) }
      it { expect(note_info).to include({ 'employeeId' => new_note.employee.uuid }) }
      it { expect(note_info).to_not include({ 'personId' => new_note.receiver.uuid }) }
    end

    context 'when data is invalid' do
      let(:description) {}

      before { subject }

      it { expect(note_info).to include({ 'description' => ["can't be blank"] }) }
    end
  end

  describe '#update' do
    let(:note) { create(:note, employee: employee) }
    let(:params) { { description: description, person_id: person_id } }
    let(:note_info) { JSON.parse(response.body) }
    let(:description) { 'Updated note' }
    let(:person_id) { receiver.uuid }

    subject do
      put "/api/v3/1on1/#{note.uuid}", params: params, headers: headers
      response
    end

    it_behaves_like 'invalid token'

    it { is_expected.to have_http_status :success }

    context 'note content' do
      before { subject }

      it { expect(note_info).to include({ 'id' => note.uuid }) }
      it { expect(note_info).to include({ 'description' => description }) }
      it { expect(note_info).to include({ 'personId' => receiver.uuid }) }
    end
  end

  describe '#destroy' do
    let(:note) { create(:note, employee: employee) }
    let(:note_info) { JSON.parse(response.body) }

    subject do
      delete "/api/v3/1on1/#{note.uuid}", headers: headers
      response
    end

    it_behaves_like 'invalid token'

    it { is_expected.to have_http_status :success }

    context 'note content' do
      before { subject }

      it { expect(note_info).to eql({ 'deleted' => 'ok' }) }
    end
  end
end
