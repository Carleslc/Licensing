class CreateActivations < ActiveRecord::Migration[5.0]
  def change
    create_table :activations do |t|
      t.text :fingerprint, null: false
      t.integer :license_id

      t.timestamps
    end
    add_index :activations, [:fingerprint, :license_id], unique: true, length: { fingerprint: 50 }
  end
end
