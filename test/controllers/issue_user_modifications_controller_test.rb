require "test_helper"

class IssueUserModificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @issue_user_modification = issue_user_modifications(:one)
  end

  test "should get index" do
    get issue_user_modifications_url
    assert_response :success
  end

  test "should get new" do
    get new_issue_user_modification_url
    assert_response :success
  end

  test "should create issue_user_modification" do
    assert_difference("IssueUserModification.count") do
      post issue_user_modifications_url, params: { issue_user_modification: { created_at: @issue_user_modification.created_at, issue_id: @issue_user_modification.issue_id, modificated_type: @issue_user_modification.modificated_type, user_id: @issue_user_modification.user_id } }
    end

    assert_redirected_to issue_user_modification_url(IssueUserModification.last)
  end

  test "should show issue_user_modification" do
    get issue_user_modification_url(@issue_user_modification)
    assert_response :success
  end

  test "should get edit" do
    get edit_issue_user_modification_url(@issue_user_modification)
    assert_response :success
  end

  test "should update issue_user_modification" do
    patch issue_user_modification_url(@issue_user_modification), params: { issue_user_modification: { created_at: @issue_user_modification.created_at, issue_id: @issue_user_modification.issue_id, modificated_type: @issue_user_modification.modificated_type, user_id: @issue_user_modification.user_id } }
    assert_redirected_to issue_user_modification_url(@issue_user_modification)
  end

  test "should destroy issue_user_modification" do
    assert_difference("IssueUserModification.count", -1) do
      delete issue_user_modification_url(@issue_user_modification)
    end

    assert_redirected_to issue_user_modifications_url
  end
end
