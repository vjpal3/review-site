require "rails_helper"

feature "User delete review", %Q{
  As an authenticated user
  I want to delete a review
  So that no one can see it
} do

  # Acceptance Criteria
  # - I must be signed in to delete the review
  # - I must be able delete the item from the item details page

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
  let!(:review_1) do
    FactoryBot.create(:review, user_id: @user.id, item_id: item.id)
  end

  scenario "authenticated user deletes a review" do
    visit "/"
    find_link("#{item.name}").click
    find_link("Delete Review").click
    expect(page).to_not have_content("Rating: #{review_1.rating}")
    expect(page).to_not have_content("Review: #{review_1.body}")
  end

  scenario "unauthenticated user attempts to delete a review" do
    find_link("Sign Out").click
    visit "/"
    find_link("#{item.name}").click
    expect(page).to_not have_link("Delete Review")
  end

end
