require 'test_helper'

class TipoasignaturasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipoasignatura = tipoasignaturas(:one)
  end

  test "should get index" do
    get tipoasignaturas_url
    assert_response :success
  end

  test "should get new" do
    get new_tipoasignatura_url
    assert_response :success
  end

  test "should create tipoasignatura" do
    assert_difference('Tipoasignatura.count') do
      post tipoasignaturas_url, params: { tipoasignatura: { descripcion: @tipoasignatura.descripcion, id: @tipoasignatura.id } }
    end

    assert_redirected_to tipoasignatura_url(Tipoasignatura.last)
  end

  test "should show tipoasignatura" do
    get tipoasignatura_url(@tipoasignatura)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipoasignatura_url(@tipoasignatura)
    assert_response :success
  end

  test "should update tipoasignatura" do
    patch tipoasignatura_url(@tipoasignatura), params: { tipoasignatura: { descripcion: @tipoasignatura.descripcion, id: @tipoasignatura.id } }
    assert_redirected_to tipoasignatura_url(@tipoasignatura)
  end

  test "should destroy tipoasignatura" do
    assert_difference('Tipoasignatura.count', -1) do
      delete tipoasignatura_url(@tipoasignatura)
    end

    assert_redirected_to tipoasignaturas_url
  end
end
