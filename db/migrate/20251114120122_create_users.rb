class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.decimal :balance, precision: 10, scale: 2, default: 0.0, null: false

      t.timestamps
    end
  end
end
