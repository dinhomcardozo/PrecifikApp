require "application_system_test_case"

class EnergiesTest < ApplicationSystemTestCase
  setup do
    @energy = energies(:one)
  end

  test "visiting the index" do
    visit energies_url
    assert_selector "h1", text: "Energies"
  end

  test "should create energy" do
    visit energies_url
    click_on "New energy"

    fill_in "Consume per hour", with: @energy. consume_per_hour
    fill_in "Description", with: @energy. description
    click_on "Create Energy"

    assert_text "Energy was successfully created"
    click_on "Back"
  end

  test "should update Energy" do
    visit energy_url(@energy)
    click_on "Edit this energy", match: :first

    fill_in "Consume per hour", with: @energy. consume_per_hour
    fill_in "Description", with: @energy. description
    click_on "Update Energy"

    assert_text "Energy was successfully updated"
    click_on "Back"
  end

  test "should destroy Energy" do
    visit energy_url(@energy)
    click_on "Destroy this energy", match: :first

    assert_text "Energy was successfully destroyed"
  end
end
