class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.text :description
      t.string :name
      t.string :phone_number
      t.string :address
      t.datetime :delivery_time
      t.float :total
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :voucher, foreign_key: true

      t.timestamps
    end
  end
end
