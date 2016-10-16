class ChangeColumnTypeFromTask < ActiveRecord::Migration[5.0]
  def change
    remove_column :tasks, :status
    add_column :tasks, :status, :integer, default: 0, null: false
  end
end
