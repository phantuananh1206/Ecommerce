class CreateVouchers < ActiveRecord::Migration[6.0]
  def change
    create_table :vouchers do |t|
      t.string :code
      t.float :discount
      t.float :condition
      t.datetime :expiry_date
      t.integer :usage_limit

      t.timestamps
    end
  end
end
