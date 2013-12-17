class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id, null: false
      t.integer :post_id, null: false
      t.integer :parent_id, null: false
      t.string :body, null: false

      t.timestamps
    end
  end
end
