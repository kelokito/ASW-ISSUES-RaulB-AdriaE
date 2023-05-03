class CreateIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :issues do |t|
      t.string :subject
      t.text :description

      t.timestamps
    end
  end
end
