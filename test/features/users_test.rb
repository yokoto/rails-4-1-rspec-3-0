require "test_helper"

feature "Users" do
  scenario "adds a new user", js: true do
    admin = create(:admin)
    sign_in admin

    visit root_path
    -> {
      click_link 'Users'
      click_link 'New User'
      fill_in 'Email', with: 'newuser@example.com'
      find('#password').fill_in 'Password', with: 'secret123'
      find('#password_confirmation').fill_in 'Password confirmation',
        with: 'secret123'
      click_button 'Create User'
    }.must_change 'User.count', 1
    current_path.must_equal users_path
    page.must_have_content 'New user created'
    within 'h1' do
      page.must_have_content 'Users'
    end
    page.must_have_content 'newuser@example.com'
  end
end
