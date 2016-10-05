class AddIndexesToUser < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :email, unique: true
    add_index :users, :api_key, unique: true
  end
end
