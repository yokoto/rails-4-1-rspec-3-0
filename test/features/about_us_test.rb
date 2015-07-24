require "test_helper"

class AboutUsTest < Capybara::Rails::TestCase
  test "toggles display of the modal about display" do
    js_true

    visit root_path

    assert_no_content page, 'About BigCo'
    assert_no_content page,
      'BigCo produces the finest widgets in all the land'

    click_link 'About Us'

    assert_content page, 'About BigCo'
    assert_content page,
      'BigCo produces the finest widgets in all the land'

    within '#about_us' do
      click_button 'Close'
    end

    assert_no_content page, 'About BigCo'
    assert_no_content page,
      'BigCo produces the finest widgets in all the land'
  end
end
