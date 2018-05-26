require "rails_helper"

feature "user views item details", %Q{
  As an authenticated user
  I want to view the details about an item
  So that I can get more information about it
} do
  # Acceptance Criteria
  # - I must be able to get to this page from the items index
  # - I must see the item's name
  # - I must see the item's description
  # - I must see the item's website, if available

  let! (:user) { FactoryBot.create(:user) }
  let! (:item_1) do
    FactoryBot.create(:item, user_id: user.id)
  end
  let! (:item_2) do
    FactoryBot.create(:item, user_id: user.id)
  end

  scenario 'views a item details' do
    visit "/"
    find_link("#{item_1.name}").click
    expect(page).to have_content("Item Details")
    expect(page).to have_content(item_1.name)
    expect(page).to have_content(item_1.description)
    expect(page).to have_content(item_1.item_website)
    expect(page).to_not have_content("item_2.name")
    expect(page).to_not have_content("item_2.description")
  end
end
