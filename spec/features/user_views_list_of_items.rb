require "rails_helper"

feature "User views list of items", %Q{
  As a user
  I want to view a list of items
  So that I can pick items to review
} do
  # Acceptance Criteria
  #   - I must see the name of each item
  #   - I must see items listed in order, most recently added first
  #   - Each item should be linked to its detail page

  let! (:user) { FactoryBot.create(:user) }
  let! (:item_1) do
    FactoryBot.create(:item, user_id: user.id)
  end
  let! (:item_2) do
    FactoryBot.create(:item, user_id: user.id)
  end

  scenario "views list of items" do
    visit "/items"
    expect(page).to have_link(item_1.name, href: "/items/#{item_1.id}")
    expect(page).to have_link(item_2.name, href: "/items/#{item_2.id}")
    expect(page.body.index("#{item_2.name}") < page.body.index("#{item_1.name}")).to eq true
  end

end
