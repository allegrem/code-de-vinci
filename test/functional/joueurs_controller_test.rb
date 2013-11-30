require 'test_helper'

class JoueursControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:joueurs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create joueur" do
    assert_difference('Joueur.count') do
      post :create, :joueur => { }
    end

    assert_redirected_to joueur_path(assigns(:joueur))
  end

  test "should show joueur" do
    get :show, :id => joueurs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => joueurs(:one).to_param
    assert_response :success
  end

  test "should update joueur" do
    put :update, :id => joueurs(:one).to_param, :joueur => { }
    assert_redirected_to joueur_path(assigns(:joueur))
  end

  test "should destroy joueur" do
    assert_difference('Joueur.count', -1) do
      delete :destroy, :id => joueurs(:one).to_param
    end

    assert_redirected_to joueurs_path
  end
end
