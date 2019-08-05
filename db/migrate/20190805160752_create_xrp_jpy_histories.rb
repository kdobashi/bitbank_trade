class CreateXrpJpyHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :xrp_jpy_histories do |t|
      t.decimal :sell
      t.decimal :buy
      t.decimal :high
      t.decimal :low
      t.string :vol
      t.timestamp :access_time

      t.timestamps
    end
  end
end
