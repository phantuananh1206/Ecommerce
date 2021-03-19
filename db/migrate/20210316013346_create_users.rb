class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :phone_number
      t.string :password
      t.integer :role, null: false, default: 1

      t.timestamps
    end
  end
end
