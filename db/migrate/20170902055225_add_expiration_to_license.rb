class AddExpirationToLicense < ActiveRecord::Migration[5.0]
  def change
    add_column :licenses, :expiration, :date
  end
end
