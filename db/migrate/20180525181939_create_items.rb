class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name, null: false, unique: true
      t.text :description, null: false
      t.string :item_website
      
      t.timestamps null: false
    end
  end
end
