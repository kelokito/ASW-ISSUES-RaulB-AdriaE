class AddAssignedToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :user_id, :integer
  end
end
