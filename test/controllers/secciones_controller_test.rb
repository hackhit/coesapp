require 'test_helper'

class SeccionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seccion = secciones(:one)
  end

  test "should get index" do
    get secciones_url
    assert_response :success
  end

  test "should get new" do
    get new_seccion_url
    assert_response :success
  end

  test "should create seccion" do
    assert_difference('Seccion.count') do
      post secciones_url, params: { seccion: { asignatura_id: @seccion.asignatura_id, calificada: @seccion.calificada, numero: @seccion.numero, periodo_id: @seccion.periodo_id, profesor_id: @seccion.profesor_id } }
    end

    assert_redirected_to seccion_url(Seccion.last)
  end

  test "should show seccion" do
    get seccion_url(@seccion)
    assert_response :success
  end

  test "should get edit" do
    get edit_seccion_url(@seccion)
    assert_response :success
  end

  test "should update seccion" do
    patch seccion_url(@seccion), params: { seccion: { asignatura_id: @seccion.asignatura_id, calificada: @seccion.calificada, numero: @seccion.numero, periodo_id: @seccion.periodo_id, profesor_id: @seccion.profesor_id } }
    assert_redirected_to seccion_url(@seccion)
  end

  test "should destroy seccion" do
    assert_difference('Seccion.count', -1) do
      delete seccion_url(@seccion)
    end

    assert_redirected_to secciones_url
  end
end
