require 'test_helper'

class PartiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:parties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create partie" do
    assert_difference('Partie.count') do
      post :create, :partie => { }
    end

    assert_redirected_to partie_path(assigns(:partie))
  end

  test "should show partie" do
    get :show, :id => parties(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => parties(:one).to_param
    assert_response :success
  end

  test "should update partie" do
    put :update, :id => parties(:one).to_param, :partie => { }
    assert_redirected_to partie_path(assigns(:partie))
  end

  test "should destroy partie" do
    assert_difference('Partie.count', -1) do
      delete :destroy, :id => parties(:one).to_param
    end

    assert_redirected_to parties_path
  end
end
