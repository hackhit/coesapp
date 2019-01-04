require "application_system_test_case"

class CartelerasTest < ApplicationSystemTestCase
  setup do
    @cartelera = carteleras(:one)
  end

  test "visiting the index" do
    visit carteleras_url
    assert_selector "h1", text: "Carteleras"
  end

  test "creating a Cartelera" do
    visit carteleras_url
    click_on "New Cartelera"

    fill_in "Contenido", with: @cartelera.contenido
    click_on "Create Cartelera"

    assert_text "Cartelera was successfully created"
    click_on "Back"
  end

  test "updating a Cartelera" do
    visit carteleras_url
    click_on "Edit", match: :first

    fill_in "Contenido", with: @cartelera.contenido
    click_on "Update Cartelera"

    assert_text "Cartelera was successfully updated"
    click_on "Back"
  end

  test "destroying a Cartelera" do
    visit carteleras_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cartelera was successfully destroyed"
  end
end
