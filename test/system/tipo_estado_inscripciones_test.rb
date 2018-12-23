require "application_system_test_case"

class TipoEstadoInscripcionesTest < ApplicationSystemTestCase
  setup do
    @tipo_estado_inscripcion = tipo_estado_inscripciones(:one)
  end

  test "visiting the index" do
    visit tipo_estado_inscripciones_url
    assert_selector "h1", text: "Tipo Estado Inscripciones"
  end

  test "creating a Tipo estado inscripcion" do
    visit tipo_estado_inscripciones_url
    click_on "New Tipo Estado Inscripcion"

    fill_in "Descripcion", with: @tipo_estado_inscripcion.descripcion
    fill_in "Id", with: @tipo_estado_inscripcion.id
    click_on "Create Tipo estado inscripcion"

    assert_text "Tipo estado inscripcion was successfully created"
    click_on "Back"
  end

  test "updating a Tipo estado inscripcion" do
    visit tipo_estado_inscripciones_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @tipo_estado_inscripcion.descripcion
    fill_in "Id", with: @tipo_estado_inscripcion.id
    click_on "Update Tipo estado inscripcion"

    assert_text "Tipo estado inscripcion was successfully updated"
    click_on "Back"
  end

  test "destroying a Tipo estado inscripcion" do
    visit tipo_estado_inscripciones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tipo estado inscripcion was successfully destroyed"
  end
end
