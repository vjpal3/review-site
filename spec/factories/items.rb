FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Lenovo Flex5 Laptop 80XA0001US #{n}" }
    description 'Featuring a top-of-the line Intel processor and a 128GB Pie SSD, you\'ll enjoy lightning-fast boot-ups and transfer times'
    item_website 'https://www.amazon.com/Lenovo-14-Inch-Laptop-Windows-80XA0001US/dp/B06X1D4167'
    # user_id "#{current_user.id}"
  end
end
