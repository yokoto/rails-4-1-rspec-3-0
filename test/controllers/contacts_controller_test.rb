require 'test_helper'

module CommonStates
  extend ActiveSupport::Concern
  included do
    let(:admin) { build_stubbed(:admin) }
    let(:user) { build_stubbed(:user) }

    let(:contact) do
      create(:contact, firstname: 'Lawrence', lastname: 'Smith')
    end

    let(:phones) do
      [
        attributes_for(:phone, phone_type: "home"),
        attributes_for(:phone, phone_type: "office"),
        attributes_for(:phone, phone_type: "mobile")
      ]
    end

    let(:valid_attributes) { attributes_for(:contact) }
    let(:invalid_attributes) { attributes_for(:invalid_contact) }
  end
end

module PublicAccessToContacts
  extend ActiveSupport::Concern
  included do
    describe 'GET #index' do
      describe 'with params[:letter]' do
        it "populates an array of contacts starting with the letter" do
          smith = create(:contact, lastname: 'Smith')
          jones = create(:contact, lastname: 'Jones')
          get :index, letter: 'S'
          assigns(:contacts).must_match_array([smith])
        end

        it "renders the :index template" do
          get :index, letter: 'S'
          must_render_template :index
        end
      end

      describe 'without params[:letter]' do
        it "populates an array of all contacts" do
          smith = create(:contact, lastname: 'Smith')
          jones = create(:contact, lastname: 'Jones')
          get :index
          assigns(:contacts).must_match_array([smith, jones])
        end

        it "renders the :index template" do
          get :index
          must_render_template :index
        end
      end
    end

    describe 'GET #show' do
      let(:contact) { build_stubbed(:contact,
        firstname: 'Lawrence', lastname: 'Smith') }

      before :each do
        Contact.stubs(:persisted?).returns(true)
        Contact.stubs(:order)
          .with('lastname, firstname').returns([contact])
        Contact.stubs(:find)
          .with(contact.id.to_s).returns(contact)
        Contact.stubs(:save).returns(true)

        get :show, id: contact
      end

      it "assigns the requested contact to @contact" do
        assigns(:contact).must_equal contact
      end

      it "renders the :show template" do
        must_render_template :show
      end
    end
  end
end

module FullAccessToContacts
  extend ActiveSupport::Concern
  included do
    describe 'GET #new' do
      it "assigns a new Contact to @contact" do
        get :new
        assigns(:contact).must_be_a_new(Contact)
      end

      it "assigns a home, office, and mobile phone to the new contact" do
        get :new
        phones = assigns(:contact).phones.map do |p|
          p.phone_type
        end
        phones.must_match_array %w(home office mobile)
      end

      it "renders the :new template" do
        get :new
        must_render_template :new
      end
    end

    describe 'GET #edit' do
      it "assigns the requested contact to @contact" do
        contact = create(:contact)
        get :edit, id: contact
        assigns(:contact).must_equal contact
      end

      it "renders the :edit template" do
        contact = create(:contact)
        get :edit, id: contact
        must_render_template :edit
      end
    end

    describe "POST #create" do
      before :each do
        @phones = [
          attributes_for(:phone),
          attributes_for(:phone),
          attributes_for(:phone)
        ]
      end

      describe "with valid attributes" do
        it "saves the new contact in the database" do
          -> {
            post :create, contact: attributes_for(:contact,
              phones_attributes: @phones)
          }.must_change 'Contact.count', 1
        end

        it "redirects to contacts#show" do
          post :create,
            contact: attributes_for(:contact,
              phones_attributes: @phones)
          must_redirect_to contact_path(assigns[:contact])
        end
      end

      describe "with invalid attributes" do
        it "does not save the new contact in the database" do
          -> {
            post :create,
              contact: attributes_for(:invalid_contact)
          }.wont_change 'Contact.count'
        end

        it "re-renders the :new template" do
          post :create,
            contact: attributes_for(:invalid_contact)
          must_render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      before :each do
        @contact = create(:contact,
          firstname: 'Lawrence',
          lastname: 'Smith'
        )
      end

      describe "valid attributes" do
        it "locates the requested @contact" do
          contact.stub :update, true do
            patch :update, id: @contact,
              contact: attributes_for(:contact)
            assigns(:contact).must_equal @contact
          end
        end

        it "changes the contact's attributes" do
          patch :update, id: @contact,
            contact: attributes_for(:contact,
              firstname: 'Larry',
              lastname: 'Smith'
            )
          @contact.reload
          @contact.firstname.must_equal 'Larry'
          @contact.lastname.must_equal 'Smith'
        end

        it "redirects to the updated contact" do
          patch :update, id: @contact, contact: attributes_for(:contact)
          must_redirect_to @contact
        end
      end

      describe "invalid attributes" do
        before :each do
          contact.stubs(:update).returns(false)
          patch :update, id: contact, contact: invalid_attributes
        end

        it "locates the requested @contact" do
          assigns(:contact).must_equal contact
        end

        it "does not change the contact's attributes" do
          assigns(:contact).reload.attributes.must_equal contact.attributes
        end

        it "re-renders the edit method" do
          must_render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @contact = create(:contact)
      end

      it "deletes the contact" do
        contact
        -> {
          delete :destroy, id: contact
        }.must_change 'Contact.count', -1
      end

      it "redirects to contacts#index" do
        delete :destroy, id: @contact
        must_redirect_to contacts_url
      end
    end
  end
end

describe ContactsController, 'administrator access' do
  include CommonStates
  include PublicAccessToContacts
  include FullAccessToContacts

  before :each do
    @controller.stubs(:current_user).returns(admin)
  end
end

describe ContactsController, 'user access' do
  include CommonStates
  include PublicAccessToContacts
  include FullAccessToContacts

  before :each do
    @controller.stubs(:current_user).returns(user)
  end
end

describe ContactsController, 'guest access' do
  include CommonStates
  include PublicAccessToContacts

  describe 'GET #new' do
    it "requires login" do
      get :new
      must_require_login
    end
  end

  describe 'GET #edit' do
    it "requires login" do
      contact = create(:contact)
      get :edit, id: contact
      must_require_login
    end
  end

  describe "POST #create" do
    it "requires login" do
      post :create, id: create(:contact),
           contact: attributes_for(:contact)
      must_require_login
    end
  end

  describe 'PUT #update' do
    it "requires login" do
      put :update, id: create(:contact),
          contact: attributes_for(:contact)
      must_require_login
    end
  end

  describe 'DELETE #destroy' do
    it "requires login" do
      delete :destroy, id: create(:contact)
      must_require_login
    end
  end
end
