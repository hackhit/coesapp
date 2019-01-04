require 'test_helper'

class CartelerasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cartelera = carteleras(:one)
  end

  test "should get index" do
    get carteleras_url
    assert_response :success
  end

  test "should get new" do
    get new_cartelera_url
    assert_response :success
  end

  test "should create cartelera" do
    assert_difference('Cartelera.count') do
      post carteleras_url, params: { cartelera: { contenido: @cartelera.contenido } }
    end

    assert_redirected_to cartelera_url(Cartelera.last)
  end

  test "should show cartelera" do
    get cartelera_url(@cartelera)
    assert_response :success
  end

  test "should get edit" do
    get edit_cartelera_url(@cartelera)
    assert_response :success
  end

  test "should update cartelera" do
    patch cartelera_url(@cartelera), params: { cartelera: { contenido: @cartelera.contenido } }
    assert_redirected_to cartelera_url(@cartelera)
  end

  test "should destroy cartelera" do
    assert_difference('Cartelera.count', -1) do
      delete cartelera_url(@cartelera)
    end

    assert_redirected_to carteleras_url
  end
end
