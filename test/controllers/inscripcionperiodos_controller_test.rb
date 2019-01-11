require 'test_helper'

class InscripcionperiodosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inscripcionperiodo = inscripcionperiodos(:one)
  end

  test "should get index" do
    get inscripcionperiodos_url
    assert_response :success
  end

  test "should get new" do
    get new_inscripcionperiodo_url
    assert_response :success
  end

  test "should create inscripcionperiodo" do
    assert_difference('Inscripcionperiodo.count') do
      post inscripcionperiodos_url, params: { inscripcionperiodo: { references: @inscripcionperiodo.references } }
    end

    assert_redirected_to inscripcionperiodo_url(Inscripcionperiodo.last)
  end

  test "should show inscripcionperiodo" do
    get inscripcionperiodo_url(@inscripcionperiodo)
    assert_response :success
  end

  test "should get edit" do
    get edit_inscripcionperiodo_url(@inscripcionperiodo)
    assert_response :success
  end

  test "should update inscripcionperiodo" do
    patch inscripcionperiodo_url(@inscripcionperiodo), params: { inscripcionperiodo: { references: @inscripcionperiodo.references } }
    assert_redirected_to inscripcionperiodo_url(@inscripcionperiodo)
  end

  test "should destroy inscripcionperiodo" do
    assert_difference('Inscripcionperiodo.count', -1) do
      delete inscripcionperiodo_url(@inscripcionperiodo)
    end

    assert_redirected_to inscripcionperiodos_url
  end
end
