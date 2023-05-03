class AddBlockedReasonToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :blocked_reason, :text
  end
end
