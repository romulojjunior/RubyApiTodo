class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.string :name, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
