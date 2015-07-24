require "test_helper"

class ContactTest < ActiveSupport::TestCase
  test "has a valid factory" do
    assert build(:contact).valid?
  end

  should validate_presence_of :firstname
  should validate_presence_of :lastname
  should validate_presence_of :email
  should validate_uniqueness_of :email

  test "returns a contact's full name as a string" do
    contact = build_stubbed(:contact,
      firstname: 'Jane',
      lastname: 'Smith'
    )
    assert_equal 'Jane Smith', contact.name
  end

  test "has three phone numbers" do
    assert_equal 3, create(:contact).phones.count
  end

  test "filter last name by letter" do
    smith = create(:contact,
      firstname: 'John',
      lastname: 'Smith',
      email: 'jsmithexample.com'
    )
    jones = create(:contact,
      firstname: 'Tim',
      lastname: 'Jones',
      email: 'tjonesexample.com'
    )
    johnson = create(:contact,
      firstname: 'John',
      lastname: 'Johnson',
      email: 'jjohnsonexample.com'
    )
    assert_equal [johnson, jones], Contact.by_letter("J")
    assert_not_includes Contact.by_letter("J"), smith
  end
end
