class AddDueDateToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :due_date, :date
  end
end
