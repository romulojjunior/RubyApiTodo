class AddColumnUserIdToCards < ActiveRecord::Migration[5.0]
  def change
    add_reference :cards, :user, foreign_key: { on_delete: :cascade }
  end
end
