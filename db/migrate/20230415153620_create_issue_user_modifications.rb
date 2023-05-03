class CreateIssueUserModifications < ActiveRecord::Migration[7.0]
  def change
    create_table :issue_user_modifications do |t|
      t.integer :issue_id
      t.integer :user_id
      t.string :modificated_type

      t.timestamps
    end
  end
end
