require "test_helper"

describe Contact do
  it "has a valid factory" do
    build(:contact).must_be :valid?
  end

  should validate_presence_of :firstname
  should validate_presence_of :lastname
  should validate_presence_of :email
  should validate_uniqueness_of(:email)

  it "returns a contact's full name as a string" do
    contact = build_stubbed(:contact,
      firstname: 'Jane',
      lastname: 'Smith'
    )
    contact.name.must_equal 'Jane Smith'
  end

  it "has three phone numbers" do
    create(:contact).phones.count.must_equal 3
  end

  describe "filter last name by letter" do
    before :each do
      @smith = create(:contact,
        firstname: 'John',
        lastname: 'Smith',
        email: 'jsmith@example.com'
      )
      @jones = create(:contact,
        firstname: 'Tim',
        lastname: 'Jones',
        email: 'tjones@example.com'
      )
      @johnson = create(:contact,
        firstname: 'John',
        lastname: 'Johnson',
        email: 'jjohnson@example.com'
      )
    end

    describe "with matching letters" do
      it "returns a sorted array of results that match" do
        Contact.by_letter("J").must_equal [@johnson, @jones]
      end
    end

    describe "with non-matching letters" do
      it "omits results that do not match" do
        Contact.by_letter("J").wont_include @smith
      end
    end
  end
end
