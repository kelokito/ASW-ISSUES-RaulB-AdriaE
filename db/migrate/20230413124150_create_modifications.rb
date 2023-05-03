class CreateModifications < ActiveRecord::Migration[7.0]
  def change
    create_table :modifications do |t|
      t.integer :user_id
      t.integer :issue_id

      t.timestamps
    end
  end
end
