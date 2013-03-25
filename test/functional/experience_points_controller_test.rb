require 'test_helper'

class ExperiencePointsControllerTest < ActionController::TestCase
  setup do
    @experience_point = experience_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:experience_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create experience_point" do
    assert_difference('ExperiencePoint.count') do
      post :create, experience_point: { experience_id: @experience_point.experience_id, points: @experience_point.points, student_id: @experience_point.student_id }
    end

    assert_redirected_to experience_point_path(assigns(:experience_point))
  end

  test "should show experience_point" do
    get :show, id: @experience_point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @experience_point
    assert_response :success
  end

  test "should update experience_point" do
    put :update, id: @experience_point, experience_point: { experience_id: @experience_point.experience_id, points: @experience_point.points, student_id: @experience_point.student_id }
    assert_redirected_to experience_point_path(assigns(:experience_point))
  end

  test "should destroy experience_point" do
    assert_difference('ExperiencePoint.count', -1) do
      delete :destroy, id: @experience_point
    end

    assert_redirected_to experience_points_path
  end
end
