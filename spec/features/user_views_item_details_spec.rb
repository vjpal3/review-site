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

  scenario "list reviews for the item, most recently posted first, if available" do
    review_1 = FactoryBot.create(:review, rating: 3, user_id: user.id, item_id: item_1.id)
    review_2 = FactoryBot.create(:review, rating: 4, user_id: user.id, item_id: item_1.id, body: "Dell's XPS 15 offers solid build quality, a stunning 4K display, great performance")

    visit "/"
    find_link("#{item_1.name}").click
    expect(page).to have_content("Item Details")
    expect(page).to have_content("Rating: 3")
    expect(page).to have_content("Rating: 4")
    expect(page).to have_content("Review: All in all, it’s your best option if you’re looking at picking up a 15-inch laptop.")
    # expect(page.body.index("Rating: 4") < page.body.index("Rating: 3")).to eq true
  end
end
