class CreateWatchers < ActiveRecord::Migration[7.0]
  def change
    create_table :watchers do |t|
      t.integer :issue_id
      t.integer :user_id

      t.timestamps
    end
  end
end
