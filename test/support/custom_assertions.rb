module CustomAssertions
  def assert_require_login
    assert_redirected_to login_path
  end

  def assert_array_matched(expected, actual)
    assert_equal expected.sort, actual.sort
  end

  def assert_a_new klass, object
    assert_instance_of klass, object
    assert_operator object, :new_record?
  end
end