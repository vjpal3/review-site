class Review < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :rating, presence: true, inclusion: { in: 0..5 }
  validates :body, length: { minimum: 50 }, allow_blank: true
end
