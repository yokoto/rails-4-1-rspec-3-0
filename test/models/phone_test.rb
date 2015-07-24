require "test_helper"

class PhoneTest < ActiveSupport::TestCase
  test "does not allow duplicate phone numbers per contact" do
    contact = create(:contact)
    create(:home_phone,
      contact: contact,
      phone: '785-555-1234'
    )
    mobile_phone = build(:mobile_phone,
      contact: contact,
      phone: '785-555-1234'
    )
    mobile_phone.valid?
    assert_includes mobile_phone.errors[:phone],
      'has already been taken'
  end

  test "allows two contacts to share a phone number" do
    create(:home_phone,
      phone: '785-555-1234'
    )
    assert build(:home_phone, phone: '785-555-1234').valid?
  end
end
