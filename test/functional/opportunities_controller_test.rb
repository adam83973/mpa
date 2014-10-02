require 'test_helper'

class OpportunitiesControllerTest < ActionController::TestCase
  setup do
    @opportunity = opportunities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:opportunities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create opportunity" do
    assert_difference('Opportunity.count') do
      post :create, opportunity: { admin_id: @opportunity.admin_id, attended_trial: @opportunity.attended_trial, offering_id: @opportunity.offering_id, possible_restart_date: @opportunity.possible_restart_date, registration_id: @opportunity.registration_id, status: @opportunity.status, student_id: @opportunity.student_id, trial_date: @opportunity.trial_date }
    end

    assert_redirected_to opportunity_path(assigns(:opportunity))
  end

  test "should show opportunity" do
    get :show, id: @opportunity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @opportunity
    assert_response :success
  end

  test "should update opportunity" do
    put :update, id: @opportunity, opportunity: { admin_id: @opportunity.admin_id, attended_trial: @opportunity.attended_trial, offering_id: @opportunity.offering_id, possible_restart_date: @opportunity.possible_restart_date, registration_id: @opportunity.registration_id, status: @opportunity.status, student_id: @opportunity.student_id, trial_date: @opportunity.trial_date }
    assert_redirected_to opportunity_path(assigns(:opportunity))
  end

  test "should destroy opportunity" do
    assert_difference('Opportunity.count', -1) do
      delete :destroy, id: @opportunity
    end

    assert_redirected_to opportunities_path
  end
end
