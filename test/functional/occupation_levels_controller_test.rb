require 'test_helper'

class OccupationLevelsControllerTest < ActionController::TestCase
  setup do
    @occupation_level = occupation_levels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:occupation_levels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create occupation_level" do
    assert_difference('OccupationLevel.count') do
      post :create, occupation_level: { level: @occupation_level.level, notes: @occupation_level.notes, points: @occupation_level.points, prevleges: @occupation_level.prevleges, rewards: @occupation_level.rewards }
    end

    assert_redirected_to occupation_level_path(assigns(:occupation_level))
  end

  test "should show occupation_level" do
    get :show, id: @occupation_level
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @occupation_level
    assert_response :success
  end

  test "should update occupation_level" do
    put :update, id: @occupation_level, occupation_level: { level: @occupation_level.level, notes: @occupation_level.notes, points: @occupation_level.points, prevleges: @occupation_level.prevleges, rewards: @occupation_level.rewards }
    assert_redirected_to occupation_level_path(assigns(:occupation_level))
  end

  test "should destroy occupation_level" do
    assert_difference('OccupationLevel.count', -1) do
      delete :destroy, id: @occupation_level
    end

    assert_redirected_to occupation_levels_path
  end
end
