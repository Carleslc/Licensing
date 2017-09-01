class CreateLicenses < ActiveRecord::Migration[5.0]
  def change
    create_table :licenses do |t|
      t.string :key
      t.string :name, null: false
      t.string :email
      t.integer :quantity, default: 1
      t.integer :product_id

      t.timestamps
    end
    add_index :licenses, :key, unique: true
  end
end
