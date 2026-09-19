require "test_helper"

class ApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alice = users(:alice)
    @bobs_application = applications(:bob_offer)
    sign_in_as(@alice)
  end

  test "index only lists the current user's applications" do
    get applications_path
    assert_response :success
    assert_match applications(:alice_applied).company, response.body
    assert_no_match(/#{Regexp.escape(@bobs_application.company)}/, response.body)
  end

  test "a user cannot update another user's application status" do
    patch update_status_application_path(@bobs_application), params: { status: "rejected" }
    assert_response :not_found
    assert_equal "offer", @bobs_application.reload.status
  end

  test "update_status transitions an owned application and responds with a turbo stream" do
    application = applications(:alice_applied)

    patch update_status_application_path(application),
          params: { status: "interview" },
          as: :turbo_stream

    assert_response :success
    assert_equal "interview", application.reload.status
    assert_match "text/vnd.turbo-stream.html", response.media_type
    assert_match "interview", response.body
  end

  test "update_status rejects an invalid status transition value" do
    application = applications(:alice_applied)

    assert_raises(ArgumentError) do
      patch update_status_application_path(application), params: { status: "not-a-status" }
    end
  end

  test "create scopes the new application to the current user" do
    assert_difference("@alice.applications.count", 1) do
      post applications_path, params: {
        application: { company: "NewCo", role: "Engineer", applied_date: Date.current, status: "applied" }
      }
    end

    assert_equal @alice, Application.last.user
  end

  private

  def sign_in_as(user)
    post session_path, params: { email: user.email, password: "password123" }
  end
end
