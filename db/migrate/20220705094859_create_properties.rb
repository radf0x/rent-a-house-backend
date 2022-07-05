class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      t.string :title, null: false
      t.string :image, null: false
      t.decimal :price, null: false
      t.string :city, null: false
      t.string :district, null: false
      t.string :road, null: false
      t.integer :rooms, null: false
      t.string :mrt_line, null: false

      t.timestamps
    end

    add_index :properties, %i[city district]
  end
end
