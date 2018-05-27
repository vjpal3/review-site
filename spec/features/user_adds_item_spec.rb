require "rails_helper"

feature "User adds an item", %Q{
  As an authenticated user
  I want to add an item
  So that others can review it
} do

  # Acceptance Criteria
    # - I must be signed in to add an item
    # - I must provide item name that is at least 20 characters long
    # - I must provide a description that is at least 50 characters long
    # - I can optionally provide item's website
    # - If I do not supply the required information, I receive an error message."
    # - If an item with that name is already in the database, I receive an error message."

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

  scenario "authenticated user successfully adds an item" do
    visit "/"
    find_link("Add Item").click
    expect(page).to have_content("Add Item to Review")
    fill_in "Name", with: "Lenovo Yoga 720"
    fill_in "Description", with: "#{item.description}"
    fill_in "Item Website", with: "#{item.item_website}"
    find_button("Add Item").click
    expect(page).to have_content("Item was successfully added")
    expect(page).to have_content("Item Details")
    expect(page).to have_content("Lenovo Yoga 720")
    expect(page).to have_content("#{item.description}")
    expect(page).to have_content("#{item.item_website}")
    expect(item.user_id).to eq(@user.id)
  end

  scenario 'authenticated user fails to add an item' do
    visit "/"
    find_link("Add Item").click
    find_button("Add Item").click
    expect(page).to have_content("errors prohibited this item from being posted")
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Name is too short (minimum is 15 characters)")
    expect(page).to have_content("Description is too short (minimum is 50 characters)")
    expect(page).to have_content("Add Item to Review")
  end

  scenario 'authenticated user fails to add an item with same name' do
    visit "/"
    find_link("Add Item").click

    fill_in "Name", with: "#{item.name}"
    fill_in "Description", with: "#{item.description}"
    fill_in "Item Website", with: "#{item.item_website}"
    find_button("Add Item").click
    expect(page).to have_content("Name has already been taken")
  end

  scenario "unauthenticated user attempts to add an item" do
    find_link("Sign Out").click
    visit "/"
    expect(page).to_not have_content("Add an Item")
  end

end
