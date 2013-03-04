require 'test_helper'

class OfferingsControllerTest < ActionController::TestCase
  setup do
    @offering = offerings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:offerings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create offering" do
    assert_difference('Offering.count') do
      post :create, offering: { comments: @offering.comments, course_id: @offering.course_id, day: @offering.day, graduation_year: @offering.graduation_year, location_id: @offering.location_id, time: @offering.time, user_id: @offering.user_id }
    end

    assert_redirected_to offering_path(assigns(:offering))
  end

  test "should show offering" do
    get :show, id: @offering
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @offering
    assert_response :success
  end

  test "should update offering" do
    put :update, id: @offering, offering: { comments: @offering.comments, course_id: @offering.course_id, day: @offering.day, graduation_year: @offering.graduation_year, location_id: @offering.location_id, time: @offering.time, user_id: @offering.user_id }
    assert_redirected_to offering_path(assigns(:offering))
  end

  test "should destroy offering" do
    assert_difference('Offering.count', -1) do
      delete :destroy, id: @offering
    end

    assert_redirected_to offerings_path
  end
end
