FactoryBot.define do
  factory :review do
    rating 2
    body "All in all, it’s your best option if you’re looking at picking up a 15-inch laptop."
    user
    item
  end
end
