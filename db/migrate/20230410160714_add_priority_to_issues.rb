class AddPriorityToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :priorityIssue, :integer
  end
end
