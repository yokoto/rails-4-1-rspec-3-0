require "test_helper"

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = create(:user)
    session[:user_id] = @user.id
  end

  test "GET #index" do
    user = create(:user)
    get :index
    assert_array_matched [@user, user], assigns(:users)
    assert_template :index
  end

  test "GET #new" do
    get :new
    assert_redirected_to root_url
  end

  test "POST #create" do
    post :create, user: attributes_for(:user)
    assert_redirected_to root_url
  end
end
