require "application_system_test_case"

class InscripcionperiodosTest < ApplicationSystemTestCase
  setup do
    @inscripcionperiodo = inscripcionperiodos(:one)
  end

  test "visiting the index" do
    visit inscripcionperiodos_url
    assert_selector "h1", text: "Inscripcionperiodos"
  end

  test "creating a Inscripcionperiodo" do
    visit inscripcionperiodos_url
    click_on "New Inscripcionperiodo"

    fill_in "References", with: @inscripcionperiodo.references
    click_on "Create Inscripcionperiodo"

    assert_text "Inscripcionperiodo was successfully created"
    click_on "Back"
  end

  test "updating a Inscripcionperiodo" do
    visit inscripcionperiodos_url
    click_on "Edit", match: :first

    fill_in "References", with: @inscripcionperiodo.references
    click_on "Update Inscripcionperiodo"

    assert_text "Inscripcionperiodo was successfully updated"
    click_on "Back"
  end

  test "destroying a Inscripcionperiodo" do
    visit inscripcionperiodos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Inscripcionperiodo was successfully destroyed"
  end
end
