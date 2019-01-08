require "application_system_test_case"

class EscuelasTest < ApplicationSystemTestCase
  setup do
    @escuela = escuelas(:one)
  end

  test "visiting the index" do
    visit escuelas_url
    assert_selector "h1", text: "Escuelas"
  end

  test "creating a Escuela" do
    visit escuelas_url
    click_on "New Escuela"

    fill_in "Descripcion", with: @escuela.descripcion
    fill_in "Id", with: @escuela.id
    click_on "Create Escuela"

    assert_text "Escuela was successfully created"
    click_on "Back"
  end

  test "updating a Escuela" do
    visit escuelas_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @escuela.descripcion
    fill_in "Id", with: @escuela.id
    click_on "Update Escuela"

    assert_text "Escuela was successfully updated"
    click_on "Back"
  end

  test "destroying a Escuela" do
    visit escuelas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Escuela was successfully destroyed"
  end
end
