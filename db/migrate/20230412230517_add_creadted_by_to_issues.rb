class AddCreadtedByToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :createdBy, :integer
  end
end
