require "rails_helper"

feature "User deletes an item", %Q{
  As an authenticated user
  I want to delete an item
  So that no one can review it
} do

  # Acceptance Criteria
  # - I must be signed in to delete the item
  # - I must be able delete the item from the item edit page
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

  scenario 'authenticated user deletes an item from item detail page' do
    visit "/"
    find_link("#{item.name}").click
    find_link("Delete Item").click
    expect(page).to_not have_content(item.name)
  end

  scenario 'authenticated user deletes an item from item edit page' do
    visit "/"
    find_link("#{item.name}").click
    find_link("Update Item").click
    find_button("Delete Item").click
    expect(page).to_not have_content(item.name)
  end

  scenario "unauthenticated user attempts to delete an item" do
    find_link("Sign Out").click
    visit "/"
    find_link("#{item.name}").click

    expect(page).to_not have_link("Delete Item")
  end
end
