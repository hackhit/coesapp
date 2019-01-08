require "application_system_test_case"

class TipoasignaturasTest < ApplicationSystemTestCase
  setup do
    @tipoasignatura = tipoasignaturas(:one)
  end

  test "visiting the index" do
    visit tipoasignaturas_url
    assert_selector "h1", text: "Tipoasignaturas"
  end

  test "creating a Tipoasignatura" do
    visit tipoasignaturas_url
    click_on "New Tipoasignatura"

    fill_in "Descripcion", with: @tipoasignatura.descripcion
    fill_in "Id", with: @tipoasignatura.id
    click_on "Create Tipoasignatura"

    assert_text "Tipoasignatura was successfully created"
    click_on "Back"
  end

  test "updating a Tipoasignatura" do
    visit tipoasignaturas_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @tipoasignatura.descripcion
    fill_in "Id", with: @tipoasignatura.id
    click_on "Update Tipoasignatura"

    assert_text "Tipoasignatura was successfully updated"
    click_on "Back"
  end

  test "destroying a Tipoasignatura" do
    visit tipoasignaturas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tipoasignatura was successfully destroyed"
  end
end
