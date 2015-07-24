require "test_helper"

class UsersTest < Capybara::Rails::TestCase
  test "adds a new user" do
    js_true

    admin = create(:admin)
    sign_in admin

    visit root_path
    assert_difference 'User.count', 1 do
      click_link 'Users'
      click_link 'New User'
      fill_in 'Email', with: 'newuser@example.com'
      find('#password').fill_in 'Password', with: 'secret123'
      find('#password_confirmation').fill_in 'Password confirmation',
        with: 'secret123'
      click_button 'Create User'
    end
    assert_equal users_path, current_path
    assert_content page, 'New user created'
    within 'h1' do
      assert_content page, 'Users'
    end
    assert_content page, 'newuser@example.com'
  end
end
