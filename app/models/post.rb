class Post < ApplicationRecord
  belongs_to :language

  validates :title, presence: true
  validates :summary, presence: true
  validates :content, presence: true

  before_validation :add_permalink

  private

  def add_permalink
    return if title.blank? || !new_record?

    self.permalink = title.parameterize
  end
end
