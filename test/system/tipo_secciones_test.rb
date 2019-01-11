require "application_system_test_case"

class TipoSeccionesTest < ApplicationSystemTestCase
  setup do
    @tipo_seccion = tipo_secciones(:one)
  end

  test "visiting the index" do
    visit tipo_secciones_url
    assert_selector "h1", text: "Tipo Secciones"
  end

  test "creating a Tipo seccion" do
    visit tipo_secciones_url
    click_on "New Tipo Seccion"

    fill_in "Descripcion", with: @tipo_seccion.descripcion
    fill_in "Id", with: @tipo_seccion.id
    click_on "Create Tipo seccion"

    assert_text "Tipo seccion was successfully created"
    click_on "Back"
  end

  test "updating a Tipo seccion" do
    visit tipo_secciones_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @tipo_seccion.descripcion
    fill_in "Id", with: @tipo_seccion.id
    click_on "Update Tipo seccion"

    assert_text "Tipo seccion was successfully updated"
    click_on "Back"
  end

  test "destroying a Tipo seccion" do
    visit tipo_secciones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tipo seccion was successfully destroyed"
  end
end
