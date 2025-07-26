require "application_system_test_case"

class TaxesTest < ApplicationSystemTestCase
  setup do
    @tax = taxes(:one)
  end

  test "visiting the index" do
    visit taxes_url
    assert_selector "h1", text: "Taxes"
  end

  test "should create tax" do
    visit taxes_url
    click_on "New tax"

    fill_in "Cbs", with: @tax.cbs
    fill_in "Description", with: @tax.description
    fill_in "Difal", with: @tax.difal
    fill_in "Ibs", with: @tax.ibs
    fill_in "Icms", with: @tax.icms
    fill_in "Ipi", with: @tax.ipi
    fill_in "Iss", with: @tax.iss
    fill_in "Note", with: @tax.note
    fill_in "Pis cofins", with: @tax.pis_cofins
    click_on "Create Tax"

    assert_text "Tax was successfully created"
    click_on "Back"
  end

  test "should update Tax" do
    visit tax_url(@tax)
    click_on "Edit this tax", match: :first

    fill_in "Cbs", with: @tax.cbs
    fill_in "Description", with: @tax.description
    fill_in "Difal", with: @tax.difal
    fill_in "Ibs", with: @tax.ibs
    fill_in "Icms", with: @tax.icms
    fill_in "Ipi", with: @tax.ipi
    fill_in "Iss", with: @tax.iss
    fill_in "Note", with: @tax.note
    fill_in "Pis cofins", with: @tax.pis_cofins
    click_on "Update Tax"

    assert_text "Tax was successfully updated"
    click_on "Back"
  end

  test "should destroy Tax" do
    visit tax_url(@tax)
    click_on "Destroy this tax", match: :first

    assert_text "Tax was successfully destroyed"
  end
end
