class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :name, null:false
      t.string :description
      t.string :status, default: 0, null: false
      t.belongs_to :card, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
