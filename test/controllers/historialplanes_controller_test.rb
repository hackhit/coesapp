require 'test_helper'

class HistorialplanesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @historialplan = historialplanes(:one)
  end

  test "should get index" do
    get historialplanes_url
    assert_response :success
  end

  test "should get new" do
    get new_historialplan_url
    assert_response :success
  end

  test "should create historialplan" do
    assert_difference('Historialplan.count') do
      post historialplanes_url, params: { historialplan: { estudiante_id: @historialplan.estudiante_id, periodo_id: @historialplan.periodo_id, plan_id: @historialplan.plan_id } }
    end

    assert_redirected_to historialplan_url(Historialplan.last)
  end

  test "should show historialplan" do
    get historialplan_url(@historialplan)
    assert_response :success
  end

  test "should get edit" do
    get edit_historialplan_url(@historialplan)
    assert_response :success
  end

  test "should update historialplan" do
    patch historialplan_url(@historialplan), params: { historialplan: { estudiante_id: @historialplan.estudiante_id, periodo_id: @historialplan.periodo_id, plan_id: @historialplan.plan_id } }
    assert_redirected_to historialplan_url(@historialplan)
  end

  test "should destroy historialplan" do
    assert_difference('Historialplan.count', -1) do
      delete historialplan_url(@historialplan)
    end

    assert_redirected_to historialplanes_url
  end
end
