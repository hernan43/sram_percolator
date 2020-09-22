require "application_system_test_case"

class SaveFilesTest < ApplicationSystemTestCase
  setup do
    @save_file = save_files(:one)
  end

  test "visiting the index" do
    visit save_files_url
    assert_selector "h1", text: "Save Files"
  end

  test "creating a Save file" do
    visit save_files_url
    click_on "New Save File"

    fill_in "Game", with: @save_file.game_id
    fill_in "Name", with: @save_file.name
    fill_in "Notes", with: @save_file.notes
    click_on "Create Save file"

    assert_text "Save file was successfully created"
    click_on "Back"
  end

  test "updating a Save file" do
    visit save_files_url
    click_on "Edit", match: :first

    fill_in "Game", with: @save_file.game_id
    fill_in "Name", with: @save_file.name
    fill_in "Notes", with: @save_file.notes
    click_on "Update Save file"

    assert_text "Save file was successfully updated"
    click_on "Back"
  end

  test "destroying a Save file" do
    visit save_files_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Save file was successfully destroyed"
  end
end
