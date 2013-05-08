require 'test_helper'

class TimePunchesControllerTest < ActionController::TestCase
  setup do
    @time_punch = time_punches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:time_punches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create time_punch" do
    assert_difference('TimePunch.count') do
      post :create, time_punch: { comment: @time_punch.comment, in: @time_punch.in, modified: @time_punch.modified, out: @time_punch.out }
    end

    assert_redirected_to time_punch_path(assigns(:time_punch))
  end

  test "should show time_punch" do
    get :show, id: @time_punch
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @time_punch
    assert_response :success
  end

  test "should update time_punch" do
    put :update, id: @time_punch, time_punch: { comment: @time_punch.comment, in: @time_punch.in, modified: @time_punch.modified, out: @time_punch.out }
    assert_redirected_to time_punch_path(assigns(:time_punch))
  end

  test "should destroy time_punch" do
    assert_difference('TimePunch.count', -1) do
      delete :destroy, id: @time_punch
    end

    assert_redirected_to time_punches_path
  end
end
