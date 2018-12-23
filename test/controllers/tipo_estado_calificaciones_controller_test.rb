require 'test_helper'

class TipoEstadoCalificacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipo_estado_calificacion = tipo_estado_calificaciones(:one)
  end

  test "should get index" do
    get tipo_estado_calificaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_tipo_estado_calificacion_url
    assert_response :success
  end

  test "should create tipo_estado_calificacion" do
    assert_difference('TipoEstadoCalificacion.count') do
      post tipo_estado_calificaciones_url, params: { tipo_estado_calificacion: { descripcion: @tipo_estado_calificacion.descripcion, id: @tipo_estado_calificacion.id } }
    end

    assert_redirected_to tipo_estado_calificacion_url(TipoEstadoCalificacion.last)
  end

  test "should show tipo_estado_calificacion" do
    get tipo_estado_calificacion_url(@tipo_estado_calificacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipo_estado_calificacion_url(@tipo_estado_calificacion)
    assert_response :success
  end

  test "should update tipo_estado_calificacion" do
    patch tipo_estado_calificacion_url(@tipo_estado_calificacion), params: { tipo_estado_calificacion: { descripcion: @tipo_estado_calificacion.descripcion, id: @tipo_estado_calificacion.id } }
    assert_redirected_to tipo_estado_calificacion_url(@tipo_estado_calificacion)
  end

  test "should destroy tipo_estado_calificacion" do
    assert_difference('TipoEstadoCalificacion.count', -1) do
      delete tipo_estado_calificacion_url(@tipo_estado_calificacion)
    end

    assert_redirected_to tipo_estado_calificaciones_url
  end
end
