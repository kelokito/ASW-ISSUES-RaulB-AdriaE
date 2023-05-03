class AddStatusToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :statusIssue, :integer
  end
end
