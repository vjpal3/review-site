require "rails_helper"

feature "user updates profile information", %Q{
  As an authenticated user
  I want to update my information
  So that I can keep my profile up to date
} do
  # acceptance_criterion
  # * I must be logged in to access my profile
  # * I will be presented with a form pre-filled with my login info, except password
  # * I must provide valid email and password to update, else I will be presented with errors

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

  scenario "authenticated user sees pre-filled form-inputs" do
    find_link("Update Profile").click

    expect(page).to have_content("Edit User")
    expect(page).to have_field("First Name", with: "#{@user.first_name}")
    expect(page).to have_field("Last Name", with: "#{@user.last_name}")
    expect(page).to have_field("Email", with: "#{@user.email}")
    expect(page).to have_button("Update")
  end

  scenario "authenticated user successfully updates profile" do
    find_link("Update Profile").click

    fill_in "First Name", with: "Suzan"
    fill_in "Last Name", with: "Williamson"
    fill_in 'Email', with: "s.williamson@example.com"
    fill_in 'Password', with: "mypassword"
    fill_in 'Password confirmation', with: 'mypassword'
    fill_in 'Current password', with: "#{@user.password}"
    find_button("Update").click
    expect(page).to have_content("updated successfully")
  end

  scenario "authenticated user fails to update profile" do
    find_link("Update Profile").click
    fill_in 'Email', with: ""
    fill_in 'Password', with: "mypwd"
    fill_in 'Password confirmation', with: "mypwd"

    click_button("Update")
    expect(page).to have_content("errors prohibited this user from being saved")
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password is too short (minimum is 6 characters)Current password can't be blank")
  end

  scenario "unauthenticated user attempts to update profile" do
    find_link("Sign Out").click
    expect(page).to_not have_content('Update Profile')
  end
end
