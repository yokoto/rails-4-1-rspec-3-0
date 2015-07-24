require "test_helper"

class NewsReleasesTest < Capybara::Rails::TestCase
  test "adds a news release as a user" do
    user = create(:user)
    sign_in(user)
    visit root_path
    click_link "News"

    assert_no_content page, "BigCo switches to Rails"
    click_link "Add News Release"

    fill_in "Date", with: "2013-07-29"
    fill_in "Title", with: "BigCo switches to Rails"
    fill_in "Body", with: \
      "BigCo has released a new website built with open source."
    click_button "Create News release"

    assert_equal news_releases_path, current_path
    assert_content page, "Successfully created news release."
    assert_content page, "2013-07-29: BigCo switches to Rails"
  end

  test "reads a news release as a guest" do
    skip "You write this one!"
    visit root_path
    click_link "News"

    assert_no_content page,
      "Today, BigCo's CFO announced record growth."
    assert_no_content page, 'Add News Release'

    click_link "2013-08-01: Record profits for BigCo!"

    assert_content page,
      "Today, BigCo's CFO announced record growth."
  end
end
