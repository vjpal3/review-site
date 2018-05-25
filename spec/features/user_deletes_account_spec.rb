require "rails_helper"

feature "authenticated use deletes own account", %Q{
  As an authenticated user
  I want to delete my account
  So that my information is no longer retained by the app
} do
  # Acceptance Criterion
  # * I must be logged in to cancel my account

  scenario "successfully delets own account" do
    @user = FactoryBot.create(:user)
    visit new_user_session_path

    fill_in "First Name", with: @user.first_name
    fill_in "Last Name", with: @user.last_name
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'
    expect(page).to have_content('Signed in successfully')

    find_link("Update Profile").click
    find_button("Cancel my account").click

    #Following code throws error:
    #Capybara::NotSupportedByDriverError: Capybara::Driver::Base#accept_modal
    # accept_confirm do
    #   click_link('Are you sure?')
    # end

    expect(page).to have_content("Your account has been successfully cancelled")
  end

  scenario "unauthenticated user attempts to delete account" do
    visit "/"
    expect(page).to_not have_content("Cancel my account")
  end


end
