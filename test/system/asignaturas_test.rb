require "application_system_test_case"

class AsignaturasTest < ApplicationSystemTestCase
  setup do
    @asignatura = asignaturas(:one)
  end

  test "visiting the index" do
    visit asignaturas_url
    assert_selector "h1", text: "Asignaturas"
  end

  test "creating a Asignatura" do
    visit asignaturas_url
    click_on "New Asignatura"

    fill_in "Anno", with: @asignatura.anno
    fill_in "Catedra", with: @asignatura.catedra_id
    fill_in "Creditos", with: @asignatura.creditos
    fill_in "Departamento", with: @asignatura.departamento_id
    fill_in "Descripcion", with: @asignatura.descripcion
    fill_in "Id", with: @asignatura.id
    fill_in "Id uxxi", with: @asignatura.id_uxxi
    click_on "Create Asignatura"

    assert_text "Asignatura was successfully created"
    click_on "Back"
  end

  test "updating a Asignatura" do
    visit asignaturas_url
    click_on "Edit", match: :first

    fill_in "Anno", with: @asignatura.anno
    fill_in "Catedra", with: @asignatura.catedra_id
    fill_in "Creditos", with: @asignatura.creditos
    fill_in "Departamento", with: @asignatura.departamento_id
    fill_in "Descripcion", with: @asignatura.descripcion
    fill_in "Id", with: @asignatura.id
    fill_in "Id uxxi", with: @asignatura.id_uxxi
    click_on "Update Asignatura"

    assert_text "Asignatura was successfully updated"
    click_on "Back"
  end

  test "destroying a Asignatura" do
    visit asignaturas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Asignatura was successfully destroyed"
  end
end
