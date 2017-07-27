require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  setup do
    @registration = registrations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registrations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create registration" do
    assert_difference('Registration.count') do
      post :create, registration: { admin_id: @registration.admin_id, attended_first_class: @registration.attended_first_class, attended_trial: @registration.attended_trial, end_date: @registration.end_date, hold_date: @registration.hold_date, offering_id: @registration.offering_id, start_date: @registration.start_date, status: @registration.status, student_id: @registration.student_id, trial_date: @registration.trial_date }
    end

    assert_redirected_to registration_path(assigns(:registration))
  end

  test "should show registration" do
    get :show, id: @registration
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @registration
    assert_response :success
  end

  test "should update registration" do
    put :update, id: @registration, registration: { admin_id: @registration.admin_id, attended_first_class: @registration.attended_first_class, attended_trial: @registration.attended_trial, end_date: @registration.end_date, hold_date: @registration.hold_date, offering_id: @registration.offering_id, start_date: @registration.start_date, status: @registration.status, student_id: @registration.student_id, trial_date: @registration.trial_date }
    assert_redirected_to registration_path(assigns(:registration))
  end

  test "should destroy registration" do
    assert_difference('Registration.count', -1) do
      delete :destroy, id: @registration
    end

    assert_redirected_to registrations_path
  end
end
