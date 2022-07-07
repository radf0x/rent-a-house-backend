class AddFloorSizeToProperty < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :floor_size, :decimal, null: false, default: BigDecimal(0)
  end
end
