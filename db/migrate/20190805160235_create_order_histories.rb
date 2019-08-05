class CreateOrderHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :order_histories do |t|
      t.integer :order_id
      t.string :pair
      t.string :side
      t.string :type
      t.decimal :start_amount
      t.decimal :remaining_amount
      t.decimal :executed_amount
      t.string :average_price
      t.timestamp :ordered_at
      t.string :status

      t.timestamps
    end
  end
end
