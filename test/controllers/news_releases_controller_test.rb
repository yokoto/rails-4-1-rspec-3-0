require "test_helper"

describe NewsReleasesController do
  describe 'GET #new' do
    it "requires login" do
      get :new
      must_require_login
    end
  end

  describe "POST #create" do
    it "requires login" do
      post :create, news_release: attributes_for(:news_release)
      must_require_login
    end
  end
end
