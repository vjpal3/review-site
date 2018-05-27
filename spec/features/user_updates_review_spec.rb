require "rails_helper"

feature "User updates review", %Q{
  As an authenticated user
  I want to update a review
  So that I can correct errors or provide new information
} do

  # Acceptance Criteria
    # - I must be signed in to update a review
    # - I must be able to get to the update page from the item details page
    # - I must see a form pre-filed with item information
    # - I must provide rating and optionally review(min. 50 chars long)
    # - If I do not supply the required information, I receive an error message."

  before(:each) do
    @user = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in "First Name", with: @user.first_name
    fill_in "Last Name", with: @user.last_name
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'
    expect(page).to have_content('Signed in successfully')
  end

  let!(:item) do
    FactoryBot.create(:item, user_id: @user.id)
  end

  scenario "authenticated user sees pre-filled form-inputs" do
    review_1 = FactoryBot.create(:review, user_id: @user.id, item_id: item.id)
    visit "/"
    find_link("#{item.name}").click
    find_link("Update Review").click

    expect(page).to have_field("Rating", with: "#{review_1.rating}")
    expect(page).to have_field("Write Review", with: "#{review_1.body}")
    expect(page).to have_button("Update Review")
  end

  scenario "authenticated user successfully updates review" do
    review_1 = FactoryBot.create(:review, user_id: @user.id, item_id: item.id)
    visit "/"
    find_link("#{item.name}").click
    find_link("Update Review").click
    select '4', from: 'Rating'
    fill_in "Write Review", with: "Find the index of the array element you want to remove, then remove that index with splice."
    click_button "Update Review"
    expect(page).to have_content("Review was successfully updated")
    expect(page).to have_content("Rating: 4")
    expect(page).to have_content("Review: Find the index of the array element you want to remove, then remove that index with splice.")
  end

  scenario "failure to update a review" do
    review_1 = FactoryBot.create(:review, user_id: @user.id, item_id: item.id)
    visit "/"
    find_link("#{item.name}").click
    find_link("Update Review").click
    select ('Select Rating'), from: 'Rating'
    fill_in "Write Review", with: ""
    click_button "Update Review"

    expect(page).to have_content("Rating can't be blank")
    expect(page).to have_field("Write Review")
  end

  scenario "unauthenticated user attempts to update a review" do
    review_1 = FactoryBot.create(:review, user_id: @user.id, item_id: item.id)
    find_link("Sign Out").click
    visit "/"
    find_link("#{item.name}").click
    
    expect(page).to have_content(review_1.rating)
    expect(page).to have_content(review_1.body)
    expect(page).to_not have_link("Update Review")
  end
end
