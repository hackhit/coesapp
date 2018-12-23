require 'test_helper'

class TipoEstadoInscripcionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipo_estado_inscripcion = tipo_estado_inscripciones(:one)
  end

  test "should get index" do
    get tipo_estado_inscripciones_url
    assert_response :success
  end

  test "should get new" do
    get new_tipo_estado_inscripcion_url
    assert_response :success
  end

  test "should create tipo_estado_inscripcion" do
    assert_difference('TipoEstadoInscripcion.count') do
      post tipo_estado_inscripciones_url, params: { tipo_estado_inscripcion: { descripcion: @tipo_estado_inscripcion.descripcion, id: @tipo_estado_inscripcion.id } }
    end

    assert_redirected_to tipo_estado_inscripcion_url(TipoEstadoInscripcion.last)
  end

  test "should show tipo_estado_inscripcion" do
    get tipo_estado_inscripcion_url(@tipo_estado_inscripcion)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipo_estado_inscripcion_url(@tipo_estado_inscripcion)
    assert_response :success
  end

  test "should update tipo_estado_inscripcion" do
    patch tipo_estado_inscripcion_url(@tipo_estado_inscripcion), params: { tipo_estado_inscripcion: { descripcion: @tipo_estado_inscripcion.descripcion, id: @tipo_estado_inscripcion.id } }
    assert_redirected_to tipo_estado_inscripcion_url(@tipo_estado_inscripcion)
  end

  test "should destroy tipo_estado_inscripcion" do
    assert_difference('TipoEstadoInscripcion.count', -1) do
      delete tipo_estado_inscripcion_url(@tipo_estado_inscripcion)
    end

    assert_redirected_to tipo_estado_inscripciones_url
  end
end
