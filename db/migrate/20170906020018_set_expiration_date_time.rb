class SetExpirationDateTime < ActiveRecord::Migration[5.0]
  def change
    change_column :licenses, :expiration, :datetime
  end
end
