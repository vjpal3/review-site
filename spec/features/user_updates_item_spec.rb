require "rails_helper"

feature "User updates item information", %Q{
  As an authenticated user
  I want to update an item's information
  So that I can correct errors or provide new information
} do

  # Acceptance Criteria
    # - I must be signed in to update an item
    # - I must be able to get to the update page from the item details page
    # - I must see a form pre-filed with item information
    # - I must provide item name that is at least 20 characters long
    # - I must provide a description that is at least 50 characters long
    # - I can optionally provide item's website
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
    visit "/"
    find_link("#{item.name}").click
    find_link("Update Item").click

    expect(page).to have_field("Name", with: "#{item.name}")
    expect(page).to have_field("Description", with: "#{item.description}")
    expect(page).to have_field("Item Website", with: "#{item.item_website}")
    expect(page).to have_button("Update Item")
  end

  scenario "authenticated user successfully updates item" do
    item_1 =  {
      name: "Inspiron Gaming Desktop",
      description: "Gaming desktop featuring powerful AMD processors, graphics ready for VR, LED lighting and a meticulous design for optimal cooling."
    }
    visit "/"
    find_link("#{item.name}").click
    find_link("Update Item").click

    expect(page).to have_content("Update Item Information")
    fill_in "Name", with: "#{item_1[:name]}"
    fill_in "Description", with: item_1[:description]
    fill_in "Item Website", with: ""
    find_button("Update Item").click

    expect(page).to have_content("Item was successfully updated")
    expect(page).to have_content("Item Details")
    expect(page).to have_content(item_1[:name])
    expect(page).to have_content(item_1[:description])
    expect(page).to_not have_content(item.item_website)
    expect(item.user_id).to eq(@user.id)
  end

  scenario 'authenticated user fails to add an item' do
    visit "/"
    find_link("#{item.name}").click
    find_link("Update Item").click

    fill_in "Name", with: ""
    fill_in "Description", with: ""
    find_button("Update Item").click
    expect(page).to have_content("errors prohibited this item from being posted")
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Name is too short (minimum is 15 characters)")
    expect(page).to have_content("Description is too short (minimum is 50 characters)")
    expect(page).to have_content("Update Item Information")
  end

  scenario "unauthenticated user attempts to update an item" do
    find_link("Sign Out").click
    visit "/"
    find_link("#{item.name}").click

    expect(page).to_not have_link("Update Item")
  end
end
