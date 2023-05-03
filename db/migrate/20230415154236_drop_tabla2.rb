class DropTabla2 < ActiveRecord::Migration[7.0]
  def change
    drop_table :modifications
  end
end
