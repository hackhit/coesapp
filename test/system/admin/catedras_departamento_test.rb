require "application_system_test_case"

class Admin::sCatedraDepartamentoTest < ApplicationSystemTestCase
  setup do
    @admin_catedra_departamento = admin_catedras_departamento(:one)
  end

  test "visiting the index" do
    visit admin_catedras_departamento_url
    assert_selector "h1", text: "Admin/S Catedra Departamento"
  end

  test "creating a Catedra departamento" do
    visit admin_catedras_departamento_url
    click_on "New Admin/Catedra Departamento"

    fill_in "Catedra", with: @admin_catedra_departamento.catedra_id
    fill_in "Departamento", with: @admin_catedra_departamento.departamento_id
    fill_in "Orden", with: @admin_catedra_departamento.orden
    click_on "Create Catedra departamento"

    assert_text "Catedra departamento was successfully created"
    click_on "Back"
  end

  test "updating a Catedra departamento" do
    visit admin_catedras_departamento_url
    click_on "Edit", match: :first

    fill_in "Catedra", with: @admin_catedra_departamento.catedra_id
    fill_in "Departamento", with: @admin_catedra_departamento.departamento_id
    fill_in "Orden", with: @admin_catedra_departamento.orden
    click_on "Update Catedra departamento"

    assert_text "Catedra departamento was successfully updated"
    click_on "Back"
  end

  test "destroying a Catedra departamento" do
    visit admin_catedras_departamento_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catedra departamento was successfully destroyed"
  end
end
