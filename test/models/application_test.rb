require "test_helper"

class ApplicationTest < ActiveSupport::TestCase
  test "valid application" do
    application = applications(:alice_applied)
    assert application.valid?
  end

  test "requires company, role, and applied_date" do
    application = Application.new(user: users(:alice))
    assert_not application.valid?
    assert_includes application.errors.attribute_names, :company
    assert_includes application.errors.attribute_names, :role
    assert_includes application.errors.attribute_names, :applied_date
  end

  test "defaults to the applied status" do
    application = Application.new(
      user: users(:alice), company: "Acme", role: "Engineer", applied_date: Date.current
    )
    assert application.applied?
  end

  test "exposes the enum status transitions" do
    application = applications(:alice_applied)
    assert application.applied?

    application.screening!
    assert application.screening?

    application.interview!
    assert application.interview?

    application.offer!
    assert application.offer?
    assert application.open?

    application.rejected!
    assert application.rejected?
    assert_not application.open?
  end

  test "rejects an unknown status value" do
    application = applications(:alice_applied)
    assert_raises(ArgumentError) { application.status = "ghosted" }
  end

  test ".active scope excludes rejected applications" do
    applications(:alice_applied).update!(status: :rejected)

    assert_not_includes Application.active, applications(:alice_applied)
    assert_includes Application.active, applications(:alice_interview)
  end

  test ".recent orders by applied_date descending" do
    ordered = Application.where(user: users(:alice)).recent.to_a
    assert_equal [applications(:alice_applied), applications(:alice_interview)], ordered
  end
end
