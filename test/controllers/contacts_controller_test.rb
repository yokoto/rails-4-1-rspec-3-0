require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
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
      test "GET #index" do
        smith = create(:contact, lastname: 'Smith')
        jones = create(:contact, lastname: 'Jones')
        get :index, letter: 'S'
        assert_array_matched [smith], assigns(:contacts)
        assert_template :index

        get :index
        assert_array_matched [smith, jones], assigns(:contacts)
        assert_template :index
      end

      test "GET #show" do
        contact = build_stubbed(:contact,
                                firstname: 'Lawrence', lastname: 'Smith')

        Contact.stubs(:persisted?).returns(true)
        Contact.stubs(:order)
            .with('lastname, firstname').returns([contact])
        Contact.stubs(:find)
            .with(contact.id.to_s).returns(contact)
        Contact.stubs(:save).returns(true)

        get :show, id: contact
        assert_equal contact, assigns(:contact)
        assert_template :show
      end
    end
  end

  module FullAccessToContacts
    extend ActiveSupport::Concern
    included do
      test "GET #new" do
        get :new
        assert_a_new Contact, assigns(:contact)

        phones = assigns(:contact).phones.map do |p|
          p.phone_type
        end
        assert_array_matched %w(home office mobile), phones
        assert_template :new
      end

      test "GET #edit" do
        contact = create(:contact)
        get :edit, id: contact
        assert_equal contact, assigns(:contact)
        assert_template :edit
      end

      test "POST #create" do
        phones = [
            attributes_for(:phone),
            attributes_for(:phone),
            attributes_for(:phone)
        ]

        assert_difference 'Contact.count', 1 do
          post :create, contact: attributes_for(:contact,
                                                phones_attributes: phones)
        end
        assert_redirected_to contact_path(assigns(:contact))

        assert_no_difference 'Contact.count' do
          post :create,
               contact: attributes_for(:invalid_contact)
        end
        assert_template :new
      end

      test "PATCH #update with valid attributes" do
        @contact = create(:contact,
                          firstname: 'Lawrence',
                          lastname: 'Smith'
        )

        contact.stub :update, true do
          patch :update, id: @contact,
                contact: attributes_for(:contact)
          assert_equal @contact, assigns(:contact)
        end

        patch :update, id: @contact,
              contact: attributes_for(:contact,
                                      firstname: 'Larry',
                                      lastname: 'Smith'
              )
        @contact.reload
        assert_equal 'Larry', @contact.firstname
        assert_equal 'Smith', @contact.lastname

        patch :update, id: @contact,
          contact: attributes_for(:contact)
        assert_redirected_to @contact
      end

      test "PATCH #update with invalid attributes" do
        contact.stub :update, false do
          patch :update, id: contact, contact: invalid_attributes
        end
        assert_equal contact, assigns(:contact)
        assert_equal contact.attributes,
                     assigns(:contact).reload.attributes
        assert_template :edit
      end

      test "DELETE #destroy" do
        @contact = create(:contact)
        contact
        assert_difference 'Contact.count', -1 do
          delete :destroy, id: @contact
        end
        assert_redirected_to contacts_url
      end
    end
  end

  class AdminAccess < ContactsControllerTest
    include CommonStates
    include PublicAccessToContacts
    include FullAccessToContacts

    setup do
      @controller.stubs(:current_user).returns(admin)
    end
  end

  class UserAccess < ContactsControllerTest
    include CommonStates
    include PublicAccessToContacts
    include FullAccessToContacts

    setup do
      @controller.stubs(:current_user).returns(user)
    end
  end

  class GuestAccess < ContactsControllerTest
    include CommonStates
    include PublicAccessToContacts

    test "GET #new" do
      get :new
      assert_require_login
    end

    test "GET #edit" do
      contact = create(:contact)
      get :edit, id: contact
      assert_require_login
    end

    test "POST #create" do
      post :create, id: create(:contact),
           contact: attributes_for(:contact)
      assert_require_login
    end

    test "PUT #update" do
      put :update, id: create(:contact),
          contact: attributes_for(:contact)
      assert_require_login
    end

    test "DELETE #destroy" do
      delete :destroy, id: create(:contact)
      assert_require_login
    end
  end
end