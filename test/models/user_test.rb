require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    assert users(:alice).valid?
  end

  test "requires a unique, well-formed email" do
    duplicate = User.new(email: users(:alice).email, password: "password123")
    assert_not duplicate.valid?
    assert_includes duplicate.errors.attribute_names, :email

    malformed = User.new(email: "not-an-email", password: "password123")
    assert_not malformed.valid?
    assert_includes malformed.errors.attribute_names, :email
  end

  test "normalizes email to a stripped, downcased form" do
    user = User.create!(email: "  Carol@Example.com  ", password: "password123")
    assert_equal "carol@example.com", user.email
  end

  test "authenticates with the correct password only" do
    user = users(:alice)
    assert user.authenticate("password123")
    assert_not user.authenticate("wrong-password")
  end

  test "application_counts_by_status includes every status even at zero" do
    counts = users(:bob).application_counts_by_status

    assert_equal 0, counts["applied"]
    assert_equal 1, counts["offer"]
    assert_equal Application.statuses.keys.sort, counts.keys.sort
  end

  test "destroying a user destroys their applications" do
    user = users(:bob)
    assert_difference("Application.count", -user.applications.count) do
      user.destroy
    end
  end
end
