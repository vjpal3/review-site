class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :rating, null: false
      t.text :body
      t.integer :user_id, null: false
      t.integer :item_id, null: false

      t.timestamps null: false
    end
  end
end
