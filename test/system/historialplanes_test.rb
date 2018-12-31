require "application_system_test_case"

class HistorialplanesTest < ApplicationSystemTestCase
  setup do
    @historialplan = historialplanes(:one)
  end

  test "visiting the index" do
    visit historialplanes_url
    assert_selector "h1", text: "Historialplanes"
  end

  test "creating a Historialplan" do
    visit historialplanes_url
    click_on "New Historialplan"

    fill_in "Estudiante", with: @historialplan.estudiante_id
    fill_in "Periodo", with: @historialplan.periodo_id
    fill_in "Plan", with: @historialplan.plan_id
    click_on "Create Historialplan"

    assert_text "Historialplan was successfully created"
    click_on "Back"
  end

  test "updating a Historialplan" do
    visit historialplanes_url
    click_on "Edit", match: :first

    fill_in "Estudiante", with: @historialplan.estudiante_id
    fill_in "Periodo", with: @historialplan.periodo_id
    fill_in "Plan", with: @historialplan.plan_id
    click_on "Update Historialplan"

    assert_text "Historialplan was successfully updated"
    click_on "Back"
  end

  test "destroying a Historialplan" do
    visit historialplanes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Historialplan was successfully destroyed"
  end
end
