require "rails_helper"

feature "user adds a review", %Q{
  As an authenticated user
  I want to add a review for an item
  so that others can know more about it
} do
  # Acceptance Criteria
  # - I must be logged in to provide  Review
  # - I must be on the item detail page
  # - I must provide a rating and optinally body of review (at least 50 characters long)
  # - I must be presented with errors if I fill out the form incorrectly

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

  scenario 'authenticated user successfully adds a review' do
    visit "/"
    find_link("#{item.name}").click

    expect(page).to have_content(item.description)
    expect(page).to have_content("Review this Item")
    select '1', from: 'Rating'
    fill_in "Write Review", with: "Find the index of the array element you want to remove, then remove that index with splice."
    click_button "Submit Review"
    expect(page).to have_content("Review was successfully posted")
    expect(page).to have_content("Rating: 1")
    expect(page).to have_content("Review: Find the index of the array element you want to remove, then remove that index with splice.")
  end

  scenario "failure to add a review" do
    visit "/"
    find_link("#{item.name}").click
    expect(page).to have_content("Review this Item")
    fill_in "Write Review", with: "Find the"
    click_button "Submit Review"

    expect(page).to have_content("Rating can't be blank")
    expect(page).to have_content("Body is too short (minimum is 50 characters)")
    expect(page).to have_field("Write Review")
  end

  scenario "unauthenticated user attempts to add a review" do
    find_link("Sign Out").click
    visit "/"
    find_link("#{item.name}").click

    expect(page).to_not have_content("Review this Item")
    expect(page).to_not have_field("Rating")
  end

end
