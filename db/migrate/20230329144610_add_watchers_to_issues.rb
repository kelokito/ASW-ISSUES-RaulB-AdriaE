class AddWatchersToIssues < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :watchers, :string
  end
end
