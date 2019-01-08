require 'test_helper'

class EscuelasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @escuela = escuelas(:one)
  end

  test "should get index" do
    get escuelas_url
    assert_response :success
  end

  test "should get new" do
    get new_escuela_url
    assert_response :success
  end

  test "should create escuela" do
    assert_difference('Escuela.count') do
      post escuelas_url, params: { escuela: { descripcion: @escuela.descripcion, id: @escuela.id } }
    end

    assert_redirected_to escuela_url(Escuela.last)
  end

  test "should show escuela" do
    get escuela_url(@escuela)
    assert_response :success
  end

  test "should get edit" do
    get edit_escuela_url(@escuela)
    assert_response :success
  end

  test "should update escuela" do
    patch escuela_url(@escuela), params: { escuela: { descripcion: @escuela.descripcion, id: @escuela.id } }
    assert_redirected_to escuela_url(@escuela)
  end

  test "should destroy escuela" do
    assert_difference('Escuela.count', -1) do
      delete escuela_url(@escuela)
    end

    assert_redirected_to escuelas_url
  end
end
