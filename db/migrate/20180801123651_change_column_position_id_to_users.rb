class ChangeColumnPositionIdToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :position_id, :integer, default: 2
  end
end
