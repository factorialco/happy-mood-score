class PollVote < ApplicationRecord
  belongs_to :poll, counter_cache: true

  validates_presence_of :result
  before_create :add_option_title

  scope :with_comments, -> { where.not(comment: nil) }
  scope :positive, -> { where(result: 30) }
  scope :neutral, -> { where(result: 20) }
  scope :negative, -> { where(result: 10) }

  private

  def add_option_title
    self.option_title = poll.poll_options.find_by(value: result).title
  end
end
