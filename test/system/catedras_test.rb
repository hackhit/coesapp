require "application_system_test_case"

class CatedrasTest < ApplicationSystemTestCase
  setup do
    @catedra = catedras(:one)
  end

  test "visiting the index" do
    visit catedras_url
    assert_selector "h1", text: "Catedras"
  end

  test "creating a Catedra" do
    visit catedras_url
    click_on "New Catedra"

    fill_in "Descripcion", with: @catedra.descripcion
    fill_in "Id", with: @catedra.id
    click_on "Create Catedra"

    assert_text "Catedra was successfully created"
    click_on "Back"
  end

  test "updating a Catedra" do
    visit catedras_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @catedra.descripcion
    fill_in "Id", with: @catedra.id
    click_on "Update Catedra"

    assert_text "Catedra was successfully updated"
    click_on "Back"
  end

  test "destroying a Catedra" do
    visit catedras_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Catedra was successfully destroyed"
  end
end
