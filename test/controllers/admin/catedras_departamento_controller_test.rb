require 'test_helper'

class Admin::CatedrasDepartamentoControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_catedra_departamento = admin_catedras_departamento(:one)
  end

  test "should get index" do
    get admin_catedras_departamento_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_catedra_departamento_url
    assert_response :success
  end

  test "should create admin_catedra_departamento" do
    assert_difference('Admin::CatedraDepartamento.count') do
      post admin_catedras_departamento_url, params: { admin_catedra_departamento: { catedra_id: @admin_catedra_departamento.catedra_id, departamento_id: @admin_catedra_departamento.departamento_id, orden: @admin_catedra_departamento.orden } }
    end

    assert_redirected_to admin_catedra_departamento_url(Admin::CatedraDepartamento.last)
  end

  test "should show admin_catedra_departamento" do
    get admin_catedra_departamento_url(@admin_catedra_departamento)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_catedra_departamento_url(@admin_catedra_departamento)
    assert_response :success
  end

  test "should update admin_catedra_departamento" do
    patch admin_catedra_departamento_url(@admin_catedra_departamento), params: { admin_catedra_departamento: { catedra_id: @admin_catedra_departamento.catedra_id, departamento_id: @admin_catedra_departamento.departamento_id, orden: @admin_catedra_departamento.orden } }
    assert_redirected_to admin_catedra_departamento_url(@admin_catedra_departamento)
  end

  test "should destroy admin_catedra_departamento" do
    assert_difference('Admin::CatedraDepartamento.count', -1) do
      delete admin_catedra_departamento_url(@admin_catedra_departamento)
    end

    assert_redirected_to admin_catedras_departamento_url
  end
end
