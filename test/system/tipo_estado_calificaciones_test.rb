require "application_system_test_case"

class TipoEstadoCalificacionesTest < ApplicationSystemTestCase
  setup do
    @tipo_estado_calificacion = tipo_estado_calificaciones(:one)
  end

  test "visiting the index" do
    visit tipo_estado_calificaciones_url
    assert_selector "h1", text: "Tipo Estado Calificaciones"
  end

  test "creating a Tipo estado calificacion" do
    visit tipo_estado_calificaciones_url
    click_on "New Tipo Estado Calificacion"

    fill_in "Descripcion", with: @tipo_estado_calificacion.descripcion
    fill_in "Id", with: @tipo_estado_calificacion.id
    click_on "Create Tipo estado calificacion"

    assert_text "Tipo estado calificacion was successfully created"
    click_on "Back"
  end

  test "updating a Tipo estado calificacion" do
    visit tipo_estado_calificaciones_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @tipo_estado_calificacion.descripcion
    fill_in "Id", with: @tipo_estado_calificacion.id
    click_on "Update Tipo estado calificacion"

    assert_text "Tipo estado calificacion was successfully updated"
    click_on "Back"
  end

  test "destroying a Tipo estado calificacion" do
    visit tipo_estado_calificaciones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tipo estado calificacion was successfully destroyed"
  end
end
