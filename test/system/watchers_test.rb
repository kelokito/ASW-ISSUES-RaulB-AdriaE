require "application_system_test_case"

class WatchersTest < ApplicationSystemTestCase
  setup do
    @watcher = watchers(:one)
  end

  test "visiting the index" do
    visit watchers_url
    assert_selector "h1", text: "Watchers"
  end

  test "should create watcher" do
    visit watchers_url
    click_on "New watcher"

    fill_in "Issue", with: @watcher.issue_id
    fill_in "User", with: @watcher.user_id
    click_on "Create Watcher"

    assert_text "Watcher was successfully created"
    click_on "Back"
  end

  test "should update Watcher" do
    visit watcher_url(@watcher)
    click_on "Edit this watcher", match: :first

    fill_in "Issue", with: @watcher.issue_id
    fill_in "User", with: @watcher.user_id
    click_on "Update Watcher"

    assert_text "Watcher was successfully updated"
    click_on "Back"
  end

  test "should destroy Watcher" do
    visit watcher_url(@watcher)
    click_on "Destroy this watcher", match: :first

    assert_text "Watcher was successfully destroyed"
  end
end
