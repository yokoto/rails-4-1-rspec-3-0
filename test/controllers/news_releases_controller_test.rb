require "test_helper"

class NewsReleasesControllerTest < ActionController::TestCase
  test "GET #new requires login" do
    get :new
    assert_require_login
  end

  test "POST #create requires login" do
    post :create, news_release: attributes_for(:news_release)
    assert_require_login
  end
end
