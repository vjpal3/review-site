class Item < ApplicationRecord
  #has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :reviews, dependent: :destroy

  validates :name, presence: true, uniqueness: true,
              length: { minimum: 15 }

  validates :description, presence: true,
              length: { minimum: 50 }

end
