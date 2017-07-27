require 'test_helper'

class EnrollmentChangeRequestsControllerTest < ActionController::TestCase
  setup do
    @enrollment_change_request = enrollment_change_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:enrollment_change_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create enrollment_change_request" do
    assert_difference('EnrollmentChangeRequest.count') do
      post :create, enrollment_change_request: { admin_id: @enrollment_change_request.admin_id, end_date: @enrollment_change_request.end_date, hold_return_date: @enrollment_change_request.hold_return_date, hold_start_date: @enrollment_change_request.hold_start_date, other_reason: @enrollment_change_request.other_reason, reason_ids: @enrollment_change_request.reason_ids, restart_billing_authorization: @enrollment_change_request.restart_billing_authorization, status: @enrollment_change_request.status, student_id: @enrollment_change_request.student_id, user_id: @enrollment_change_request.user_id }
    end

    assert_redirected_to enrollment_change_request_path(assigns(:enrollment_change_request))
  end

  test "should show enrollment_change_request" do
    get :show, id: @enrollment_change_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @enrollment_change_request
    assert_response :success
  end

  test "should update enrollment_change_request" do
    put :update, id: @enrollment_change_request, enrollment_change_request: { admin_id: @enrollment_change_request.admin_id, end_date: @enrollment_change_request.end_date, hold_return_date: @enrollment_change_request.hold_return_date, hold_start_date: @enrollment_change_request.hold_start_date, other_reason: @enrollment_change_request.other_reason, reason_ids: @enrollment_change_request.reason_ids, restart_billing_authorization: @enrollment_change_request.restart_billing_authorization, status: @enrollment_change_request.status, student_id: @enrollment_change_request.student_id, user_id: @enrollment_change_request.user_id }
    assert_redirected_to enrollment_change_request_path(assigns(:enrollment_change_request))
  end

  test "should destroy enrollment_change_request" do
    assert_difference('EnrollmentChangeRequest.count', -1) do
      delete :destroy, id: @enrollment_change_request
    end

    assert_redirected_to enrollment_change_requests_path
  end
end
