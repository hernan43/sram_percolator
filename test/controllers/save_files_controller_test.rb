require 'test_helper'

class SaveFilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @save_file = save_files(:one)
  end

  test "should get index" do
    get save_files_url
    assert_response :success
  end

  test "should get new" do
    get new_save_file_url
    assert_response :success
  end

  test "should create save_file" do
    assert_difference('SaveFile.count') do
      post save_files_url, params: { save_file: { game_id: @save_file.game_id, name: @save_file.name, notes: @save_file.notes } }
    end

    assert_redirected_to save_file_url(SaveFile.last)
  end

  test "should show save_file" do
    get save_file_url(@save_file)
    assert_response :success
  end

  test "should get edit" do
    get edit_save_file_url(@save_file)
    assert_response :success
  end

  test "should update save_file" do
    patch save_file_url(@save_file), params: { save_file: { game_id: @save_file.game_id, name: @save_file.name, notes: @save_file.notes } }
    assert_redirected_to save_file_url(@save_file)
  end

  test "should destroy save_file" do
    assert_difference('SaveFile.count', -1) do
      delete save_file_url(@save_file)
    end

    assert_redirected_to save_files_url
  end
end
