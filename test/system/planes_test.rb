require "application_system_test_case"

class PlanesTest < ApplicationSystemTestCase
  setup do
    @plan = planes(:one)
  end

  test "visiting the index" do
    visit planes_url
    assert_selector "h1", text: "Planes"
  end

  test "creating a Plan" do
    visit planes_url
    click_on "New Plan"

    fill_in "Description", with: @plan.description
    fill_in "Id", with: @plan.id
    click_on "Create Plan"

    assert_text "Plan was successfully created"
    click_on "Back"
  end

  test "updating a Plan" do
    visit planes_url
    click_on "Edit", match: :first

    fill_in "Description", with: @plan.description
    fill_in "Id", with: @plan.id
    click_on "Update Plan"

    assert_text "Plan was successfully updated"
    click_on "Back"
  end

  test "destroying a Plan" do
    visit planes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Plan was successfully destroyed"
  end
end
