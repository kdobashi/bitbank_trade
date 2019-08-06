class AddColumnToXrpJpyHistories2 < ActiveRecord::Migration[5.2]
  def change
    add_column :xrp_jpy_histories, :last, :decimal
  end
end
