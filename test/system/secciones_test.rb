require "application_system_test_case"

class SeccionesTest < ApplicationSystemTestCase
  setup do
    @seccion = secciones(:one)
  end

  test "visiting the index" do
    visit secciones_url
    assert_selector "h1", text: "Secciones"
  end

  test "creating a Seccion" do
    visit secciones_url
    click_on "New Seccion"

    fill_in "Asignatura", with: @seccion.asignatura_id
    fill_in "Calificada", with: @seccion.calificada
    fill_in "Numero", with: @seccion.numero
    fill_in "Periodo", with: @seccion.periodo_id
    fill_in "Profesor", with: @seccion.profesor_id
    click_on "Create Seccion"

    assert_text "Seccion was successfully created"
    click_on "Back"
  end

  test "updating a Seccion" do
    visit secciones_url
    click_on "Edit", match: :first

    fill_in "Asignatura", with: @seccion.asignatura_id
    fill_in "Calificada", with: @seccion.calificada
    fill_in "Numero", with: @seccion.numero
    fill_in "Periodo", with: @seccion.periodo_id
    fill_in "Profesor", with: @seccion.profesor_id
    click_on "Update Seccion"

    assert_text "Seccion was successfully updated"
    click_on "Back"
  end

  test "destroying a Seccion" do
    visit secciones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Seccion was successfully destroyed"
  end
end
