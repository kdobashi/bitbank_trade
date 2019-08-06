class ChangeColumnToOrderHistories < ActiveRecord::Migration[5.2]
  def up
    change_column :order_histories, :average_price, 'decimal USING CAST(average_price AS decimal)' 
  end

  def down
    change_column :order_histories, :average_price, :string
  end
end
