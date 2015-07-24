module CustomAssertions
  def assert_require_login(*)
    assert_redirected_to login_path
  end
  infect_an_assertion :assert_require_login, :must_require_login

  def assert_array_matched(expected, actual)
    assert_equal expected.sort, actual.sort
  end
  Array.infect_an_assertion :assert_array_matched, :must_match_array

  def assert_a_new(klass, object)
    assert_instance_of klass, object
    assert_operator object, :new_record?
  end
  ActiveRecord::Base.infect_an_assertion :assert_a_new, :must_be_a_new
end
