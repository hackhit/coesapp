require 'test_helper'

class CatedrasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catedra = catedras(:one)
  end

  test "should get index" do
    get catedras_url
    assert_response :success
  end

  test "should get new" do
    get new_catedra_url
    assert_response :success
  end

  test "should create catedra" do
    assert_difference('Catedra.count') do
      post catedras_url, params: { catedra: { descripcion: @catedra.descripcion, id: @catedra.id } }
    end

    assert_redirected_to catedra_url(Catedra.last)
  end

  test "should show catedra" do
    get catedra_url(@catedra)
    assert_response :success
  end

  test "should get edit" do
    get edit_catedra_url(@catedra)
    assert_response :success
  end

  test "should update catedra" do
    patch catedra_url(@catedra), params: { catedra: { descripcion: @catedra.descripcion, id: @catedra.id } }
    assert_redirected_to catedra_url(@catedra)
  end

  test "should destroy catedra" do
    assert_difference('Catedra.count', -1) do
      delete catedra_url(@catedra)
    end

    assert_redirected_to catedras_url
  end
end
