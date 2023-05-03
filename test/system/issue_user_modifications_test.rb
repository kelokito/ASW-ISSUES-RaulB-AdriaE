require "application_system_test_case"

class IssueUserModificationsTest < ApplicationSystemTestCase
  setup do
    @issue_user_modification = issue_user_modifications(:one)
  end

  test "visiting the index" do
    visit issue_user_modifications_url
    assert_selector "h1", text: "Issue user modifications"
  end

  test "should create issue user modification" do
    visit issue_user_modifications_url
    click_on "New issue user modification"

    fill_in "Created at", with: @issue_user_modification.created_at
    fill_in "Issue", with: @issue_user_modification.issue_id
    fill_in "Modificated type", with: @issue_user_modification.modificated_type
    fill_in "User", with: @issue_user_modification.user_id
    click_on "Create Issue user modification"

    assert_text "Issue user modification was successfully created"
    click_on "Back"
  end

  test "should update Issue user modification" do
    visit issue_user_modification_url(@issue_user_modification)
    click_on "Edit this issue user modification", match: :first

    fill_in "Created at", with: @issue_user_modification.created_at
    fill_in "Issue", with: @issue_user_modification.issue_id
    fill_in "Modificated type", with: @issue_user_modification.modificated_type
    fill_in "User", with: @issue_user_modification.user_id
    click_on "Update Issue user modification"

    assert_text "Issue user modification was successfully updated"
    click_on "Back"
  end

  test "should destroy Issue user modification" do
    visit issue_user_modification_url(@issue_user_modification)
    click_on "Destroy this issue user modification", match: :first

    assert_text "Issue user modification was successfully destroyed"
  end
end
