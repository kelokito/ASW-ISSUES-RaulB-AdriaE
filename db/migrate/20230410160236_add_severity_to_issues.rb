class AddSeverityToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :severityIssue, :integer
  end
end
