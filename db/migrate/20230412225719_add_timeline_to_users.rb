class AddTimelineToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :timeline, :string
  end
end
