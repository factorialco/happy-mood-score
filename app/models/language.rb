class Language < ApplicationRecord
  has_many :companies
  has_many :employees
  has_many :posts

  validates :name, presence: true
  validates :code, presence: true
end
