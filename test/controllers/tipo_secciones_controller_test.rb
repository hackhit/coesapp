require 'test_helper'

class TipoSeccionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipo_seccion = tipo_secciones(:one)
  end

  test "should get index" do
    get tipo_secciones_url
    assert_response :success
  end

  test "should get new" do
    get new_tipo_seccion_url
    assert_response :success
  end

  test "should create tipo_seccion" do
    assert_difference('TipoSeccion.count') do
      post tipo_secciones_url, params: { tipo_seccion: { descripcion: @tipo_seccion.descripcion, id: @tipo_seccion.id } }
    end

    assert_redirected_to tipo_seccion_url(TipoSeccion.last)
  end

  test "should show tipo_seccion" do
    get tipo_seccion_url(@tipo_seccion)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipo_seccion_url(@tipo_seccion)
    assert_response :success
  end

  test "should update tipo_seccion" do
    patch tipo_seccion_url(@tipo_seccion), params: { tipo_seccion: { descripcion: @tipo_seccion.descripcion, id: @tipo_seccion.id } }
    assert_redirected_to tipo_seccion_url(@tipo_seccion)
  end

  test "should destroy tipo_seccion" do
    assert_difference('TipoSeccion.count', -1) do
      delete tipo_seccion_url(@tipo_seccion)
    end

    assert_redirected_to tipo_secciones_url
  end
end
