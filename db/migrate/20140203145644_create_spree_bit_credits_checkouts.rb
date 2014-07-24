class CreateSpreeBitCreditsCheckouts < ActiveRecord::Migration
  def up
    create_table :bit_credits_checkouts do |t|
      t.float :old_balance
      t.float :new_balance
      t.string :source
      t.integer :tx_id
    end
  end

  def down
    drop_table :bit_credits_checkouts
  end
end
