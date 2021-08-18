require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { build(:post) }

  it_behaves_like 'uuidable'

  it { is_expected.to belong_to :language }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:summary) }
  it { is_expected.to validate_presence_of(:content) }

  describe 'create' do
    let(:new_post) { create(:post, title: 'Flotsam And Jetsam') }

    subject { new_post }

    its(:permalink) { is_expected.to eql 'flotsam-and-jetsam' }

    context 'when title is updated' do
      before { new_post.update(title: 'Death Angel') }

      its(:permalink) { is_expected.to eql 'flotsam-and-jetsam' }
      its(:title) { is_expected.to eql 'Death Angel' }
    end
  end
end
