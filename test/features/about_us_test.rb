require "test_helper"

feature "AboutUs" do
  scenario "toggles display of the modal about display", js: true do
    visit root_path

    page.wont_have_content 'About BigCo'
    page.wont_have_content \
      'BigCo produces the finest widgets in all the land'

    click_link 'About Us'

    page.must_have_content 'About BigCo'
    page.must_have_content \
      'BigCo produces the finest widgets in all the land'

    within '#about_us' do
      click_button 'Close'
    end

    page.wont_have_content 'About BigCo'
    page.wont_have_content \
      'BigCo produces the finest widgets in all the land'
  end
end
